-- Claude Code session manager: lists the Claude sessions running on this
-- machine (in nvim tabs or in other terminal windows), starts new ones in tabs,
-- resumes old ones and says when a session needs you.
--
-- Live state comes from ~/.claude/sessions/<pid>.json, which Claude Code keeps
-- up to date (status busy / waiting / idle). Past sessions come from
-- ~/.claude/history.jsonl (every prompt you typed). Both are internal files, so
-- a Claude Code update may change them.
local M = {}

local uv = vim.uv
local claude_dir = vim.fs.normalize('~/.claude')

local ok, localcfg = pcall(require, 'yogan.local')
if not ok or type(localcfg) ~= 'table' then localcfg = {} end

M.status_info = {
    waiting = { icon = '●', label = 'needs you', hl = 'DiagnosticError', order = 1 },
    idle = { icon = '○', label = 'your turn', hl = 'DiagnosticWarn', order = 2 },
    busy = { icon = '◐', label = 'working', hl = 'DiagnosticInfo', order = 3 },
}
local unknown_status = { icon = '?', label = 'unknown', hl = 'Comment', order = 4 }

function M.info(status) return M.status_info[status] or unknown_status end

-- pid -> terminal buffer, for sessions started from this nvim
local terminals = {}

local function read_json(path)
    local lines = vim.fn.readfile(path)
    local decoded, data = pcall(vim.json.decode, table.concat(lines, '\n'))
    if decoded then return data end
end

local function alive(pid) return type(pid) == 'number' and uv.kill(pid, 0) == 0 end

local function ago(ms)
    local s = os.time() - math.floor((ms or 0) / 1000)
    if s < 60 then return s .. 's' end
    if s < 3600 then return math.floor(s / 60) .. 'm' end
    if s < 86400 then return math.floor(s / 3600) .. 'h' end
    return math.floor(s / 86400) .. 'd'
end

local function one_line(text) return (text or ''):gsub('%s+', ' ') end

--- Running interactive sessions, the ones that need you first.
function M.live()
    local sessions = {}
    local dir = claude_dir .. '/sessions'
    if vim.fn.isdirectory(dir) == 0 then return sessions end
    for name, type in vim.fs.dir(dir) do
        if type == 'file' and name:match('%.json$') then
            local s = read_json(dir .. '/' .. name)
            if s and s.kind == 'interactive' and alive(s.pid) then
                s.buf = terminals[s.pid]
                if s.buf and not vim.api.nvim_buf_is_valid(s.buf) then s.buf = nil end
                table.insert(sessions, s)
            end
        end
    end
    table.sort(sessions, function(a, b)
        local oa, ob = M.info(a.status).order, M.info(b.status).order
        if oa ~= ob then return oa < ob end
        return (a.statusUpdatedAt or 0) > (b.statusUpdatedAt or 0)
    end)
    return sessions
end

local history_cache = { mtime = nil, list = {}, by_id = {} }

--- Past sessions (with the prompts typed in them), newest first, and a lookup
--- by session id.
function M.history()
    local path = claude_dir .. '/history.jsonl'
    local stat = uv.fs_stat(path)
    if not stat then return {}, {} end
    local mtime = stat.mtime.sec .. '.' .. stat.mtime.nsec
    if history_cache.mtime == mtime then return history_cache.list, history_cache.by_id end

    local by_id, list = {}, {}
    for line in io.lines(path) do
        local decoded, entry = pcall(vim.json.decode, line)
        if decoded and type(entry) == 'table' and entry.sessionId then
            local s = by_id[entry.sessionId]
            if not s then
                s = { id = entry.sessionId, project = entry.project, prompts = {} }
                by_id[entry.sessionId] = s
                table.insert(list, s)
            end
            table.insert(s.prompts, entry.display or '')
            s.last = entry.timestamp or s.last
        end
    end
    table.sort(list, function(a, b) return (a.last or 0) > (b.last or 0) end)
    history_cache = { mtime = mtime, list = list, by_id = by_id }
    return list, by_id
end

--- Start Claude in a new tab, in `dir` (default: cwd), with extra CLI `args`.
function M.open(dir, args)
    dir = vim.fs.normalize(dir or vim.fn.getcwd())
    if vim.fn.isdirectory(dir) == 0 then
        vim.notify('Claude: directory does not exist: ' .. dir, vim.log.levels.ERROR)
        return
    end
    local cmd = { localcfg.claude_cmd or 'claude' }
    vim.list_extend(cmd, localcfg.claude_args or {})
    vim.list_extend(cmd, args or {})

    vim.cmd.tabnew()
    vim.cmd.tcd(vim.fn.fnameescape(dir))
    local buf = vim.api.nvim_get_current_buf()
    local job = vim.fn.jobstart(cmd, { term = true, cwd = dir })
    if job <= 0 then
        vim.notify('Claude: could not start ' .. cmd[1], vim.log.levels.ERROR)
        return
    end
    terminals[vim.fn.jobpid(job)] = buf
    vim.b[buf].claude = true
end

local focus_terminal_tab = [[
tell application "Terminal"
    repeat with w in windows
        repeat with t in tabs of w
            if tty of t is "%s" then
                set selected of t to true
                set index of w to 1
                activate
                return "ok"
            end if
        end repeat
    end repeat
end tell]]

--- Jump to a live session: its nvim tab, or the terminal window it runs in.
function M.focus(s)
    if s.buf then
        local win = vim.fn.win_findbuf(s.buf)[1]
        if win then
            vim.api.nvim_set_current_win(win)
        else
            vim.cmd('tab sbuffer ' .. s.buf)
        end
        vim.cmd.startinsert()
        return
    end

    local tty = vim.trim(vim.fn.system { 'ps', '-o', 'tty=', '-p', tostring(s.pid) })
    local function cannot()
        vim.notify(('Claude %s runs in another terminal (%s), could not focus it'):format(s.name, tty))
    end
    if vim.fn.has('mac') == 0 or tty == '' or tty == '??' then return cannot() end
    vim.system({ 'osascript', '-e', focus_terminal_tab:format('/dev/' .. tty) }, { text = true }, function(r)
        if r.code ~= 0 or vim.trim(r.stdout or '') ~= 'ok' then vim.schedule(cannot) end
    end)
end

M.counts = { waiting = 0, idle = 0, busy = 0 }
local last_status -- pid -> status from the previous poll

--- Refresh counts and notify when a session stops working (finished or needs
--- input), unless it is the buffer you are looking at.
function M.poll()
    local counts = { waiting = 0, idle = 0, busy = 0 }
    local now = {}
    for _, s in ipairs(M.live()) do
        now[s.pid] = s.status
        if counts[s.status] then counts[s.status] = counts[s.status] + 1 end

        local before = last_status and last_status[s.pid]
        local looking = s.buf and s.buf == vim.api.nvim_get_current_buf()
        if before and before ~= s.status and s.status ~= 'busy' and not looking then
            local msg = ('Claude %s: %s'):format(s.name or vim.fs.basename(s.cwd), M.info(s.status).label)
            if s.waitingFor then msg = msg .. ' (' .. s.waitingFor .. ')' end
            local level = s.status == 'waiting' and vim.log.levels.WARN or vim.log.levels.INFO
            vim.notify(msg, level, { title = 'Claude' })
        end
    end
    last_status = now

    if not vim.deep_equal(counts, M.counts) then
        M.counts = counts
        local lualine_ok, lualine = pcall(require, 'lualine')
        if lualine_ok then lualine.refresh() end
    end
end

--- lualine component for one status: "● 2 needs you"; empty when none.
function M.statusline(status)
    return function()
        local n = M.counts[status] or 0
        if n == 0 then return '' end
        local info = M.info(status)
        return ('%s %d %s'):format(info.icon, n, info.label)
    end
end

function M.start_watching(interval_ms)
    if M.timer then return end
    M.timer = uv.new_timer()
    M.timer:start(1000, interval_ms or 2000, vim.schedule_wrap(M.poll))
end

-- Telescope pickers ---------------------------------------------------------

local function prompts_previewer(get_session)
    local previewers = require('telescope.previewers')
    return previewers.new_buffer_previewer {
        title = 'Prompts',
        define_preview = function(self, entry)
            local lines = {}
            local s, past = get_session(entry)
            if s then
                vim.list_extend(lines, {
                    'Status:  ' .. M.info(s.status).label .. (s.waitingFor and (' (' .. s.waitingFor .. ')') or ''),
                    'Where:   ' .. (s.buf and 'nvim tab' or 'other terminal window'),
                    'Dir:     ' .. s.cwd,
                    '',
                })
            elseif past then
                vim.list_extend(lines, { 'Dir:     ' .. (past.project or '?'), '' })
            end
            for _, prompt in ipairs(past and past.prompts or {}) do
                table.insert(lines, '> ' .. vim.split(prompt, '\n')[1])
                for i, l in ipairs(vim.split(prompt, '\n')) do
                    if i > 1 then table.insert(lines, '  ' .. l) end
                end
            end
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
            vim.wo[self.state.winid].wrap = true
        end,
    }
end

--- Picker of running sessions; <CR> jumps to it.
function M.pick_live()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local entry_display = require('telescope.pickers.entry_display')

    local sessions = M.live()
    if #sessions == 0 then
        vim.notify('No Claude sessions running')
        return
    end
    local _, by_id = M.history()

    local displayer = entry_display.create {
        separator = ' ',
        items = { { width = 1 }, { width = 9 }, { width = 24 }, { width = 4 }, { width = 4 }, { remaining = true } },
    }

    pickers
        .new({}, {
            prompt_title = 'Claude sessions',
            finder = finders.new_table {
                results = sessions,
                entry_maker = function(s)
                    local info = M.info(s.status)
                    local past = by_id[s.sessionId]
                    local last_prompt = past and one_line(past.prompts[#past.prompts]) or ''
                    return {
                        value = s,
                        display = function()
                            return displayer {
                                { info.icon, info.hl },
                                { info.label, info.hl },
                                s.name or vim.fs.basename(s.cwd),
                                { ago(s.statusUpdatedAt), 'Comment' },
                                { s.buf and 'nvim' or 'term', 'Comment' },
                                last_prompt,
                            }
                        end,
                        ordinal = table.concat({ s.name or '', s.cwd, info.label, last_prompt }, ' '),
                    }
                end,
            },
            sorter = conf.generic_sorter {},
            previewer = prompts_previewer(function(entry) return entry.value, by_id[entry.value.sessionId] end),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local entry = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if entry then M.focus(entry.value) end
                end)
                return true
            end,
        })
        :find()
end

--- Picker of past sessions; <CR> resumes one in a new tab (or jumps to it if it
--- is still running), <C-n> starts a new session in its project.
function M.pick_history()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local entry_display = require('telescope.pickers.entry_display')

    local list = M.history()
    local running = {}
    for _, s in ipairs(M.live()) do
        running[s.sessionId] = s
    end

    local displayer = entry_display.create {
        separator = ' ',
        items = { { width = 1 }, { width = 4 }, { width = 20 }, { remaining = true } },
    }

    pickers
        .new({}, {
            prompt_title = 'Resume Claude session (<C-n>: new session in that project)',
            finder = finders.new_table {
                results = list,
                entry_maker = function(past)
                    local live = running[past.id]
                    local info = live and M.info(live.status)
                    local first = one_line(past.prompts[1])
                    return {
                        value = past,
                        display = function()
                            return displayer {
                                info and { info.icon, info.hl } or ' ',
                                { ago(past.last), 'Comment' },
                                vim.fs.basename(past.project or '?'),
                                first,
                            }
                        end,
                        -- search the project and everything typed in the session
                        ordinal = (past.project or '') .. ' ' .. table.concat(past.prompts, ' '):sub(1, 2000),
                    }
                end,
            },
            sorter = conf.generic_sorter {},
            previewer = prompts_previewer(function(entry) return running[entry.value.id], entry.value end),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    local entry = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if not entry then return end
                    local live = running[entry.value.id]
                    if live then
                        M.focus(live)
                    else
                        M.open(entry.value.project, { '--resume', entry.value.id })
                    end
                end)
                map({ 'i', 'n' }, '<C-n>', function()
                    local entry = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if entry then M.open(entry.value.project) end
                end)
                return true
            end,
        })
        :find()
end

return M
