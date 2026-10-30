# New Mac checklist

Everything `./bootstrap.sh` can't do by itself. Work top to bottom; each step
is safe to repeat. (Claude: do what you can from the terminal, and for steps
that need a GUI or a password, tell me exactly what to click or type.)

## Bootstrap

1. `./bootstrap.sh` (asks for your password for Homebrew; re-run it after the
   Command Line Tools finish installing if it stops there).

## After bootstrap

2. Open Bitwarden (installed by the `Brewfile`) and sign in. The secrets below
   come from it.
3. Use Homebrew's bash as the login shell (macOS's `/bin/bash` is 3.2 from 2007):
   ```sh
   echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
   chsh -s /opt/homebrew/bin/bash
   ```
4. SSH: copy `~/.ssh/config.d/private` (the ssh hosts) from the old Mac or
   Bitwarden.
   GitHub: `gh auth login`, then `gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(scutil --get ComputerName)"`.
5. Claude Code: run `claude` and log in. Plugins listed in
   `claude/settings.json` come from the marketplaces there; install any that
   are missing with `/plugin`. Recreate the graphify skill with
   `graphify install --platform claude`. Copy
   `~/.claude/settings.private.json` (the 2anki.net ssh rules and auto-mode
   notes) from the old Mac or Bitwarden, then run `bin/claude-settings build`.
6. Fill in `~/.shell/local` (not in git). Current machine has:
   ```sh
   export ASC_KEY_ID=...        # App Store Connect API (Bitwarden)
   export ASC_ISSUER_ID=...
   # Google Cloud SDK, if installed to ~/google-cloud-sdk
   . "$HOME/google-cloud-sdk/path.bash.inc"
   . "$HOME/google-cloud-sdk/completion.bash.inc"
   ```
   and copy `~/.appstoreconnect/private_keys/AuthKey_*.p8` from Bitwarden.
7. Mail: copy `~/.config/himalaya/config.toml` from the old Mac; its passwords
   live in the Keychain (`security add-generic-password ...`).
8. Grant Accessibility / Input Monitoring when asked: Raycast, Rectangle,
   Hidden Bar. Raycast: import settings (Raycast →
   Settings → Advanced → Import) or sign in for cloud sync.
9. Apps that are not in the `Brewfile` yet. Install by hand, or add a
   `cask "..."` line and run `brew bundle`:
   Claude, cmux, Google Chrome, Anki, AppCleaner, Cap, Zoom, NordVPN,
   Godot, DaVinci Resolve, Microsoft Edge, RØDE Central.
   App Store only (nothing installs these automatically, so no Apple ID
   prompts): Xcode, Developer, Kindle, Microsoft Office, OneDrive, RetroArch.
