-- Animated cursor trail. Neovide has its own cursor animation (see neovide.lua).
if vim.g.neovide then return end

require('smear_cursor').setup {
    -- snappier than the defaults (values from the README's "Faster smear")
    stiffness = 0.8,
    trailing_stiffness = 0.6,
    stiffness_insert_mode = 0.7,
    trailing_stiffness_insert_mode = 0.7,
    damping = 0.95,
    damping_insert_mode = 0.95,
    distance_stop_animating = 0.5,
}
