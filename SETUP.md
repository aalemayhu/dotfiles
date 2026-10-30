# New Mac checklist

Everything `./bootstrap.sh` can't do by itself. Work top to bottom; each step
is safe to repeat. (Claude: do what you can from the terminal, and for steps
that need a GUI or a password, tell me exactly what to click or type.)

## Bootstrap

1. `./bootstrap.sh`. It asks for your password once, at the start (Homebrew
   and the login shell need root), then runs without any further input.

## After bootstrap

2. Open Bitwarden (installed by the `Brewfile`) and sign in. The secrets below
   come from it.
3. SSH: copy `~/.ssh/config.d/private` (the ssh hosts) from the old Mac or
   Bitwarden.
   GitHub: `gh auth login`, then `gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(scutil --get ComputerName)"`.
4. Claude Code: run `claude` and log in. Plugins listed in
   `claude/settings.json` come from the marketplaces there; install any that
   are missing with `/plugin`. Recreate the graphify skill with
   `graphify install --platform claude`. Claude Code works without
   `~/.claude/settings.private.json` (bootstrap starts it empty); you only get
   permission prompts for the 2anki.net ssh rules it would hold. To add them,
   put the rules in that file and run `bin/claude-settings build`.
5. Fill in `~/.shell/local` (not in git). Current machine has:
   ```sh
   export ASC_KEY_ID=...        # App Store Connect API (Bitwarden)
   export ASC_ISSUER_ID=...
   # Google Cloud SDK, if installed to ~/google-cloud-sdk
   . "$HOME/google-cloud-sdk/path.bash.inc"
   . "$HOME/google-cloud-sdk/completion.bash.inc"
   ```
   and copy `~/.appstoreconnect/private_keys/AuthKey_*.p8` from Bitwarden.
6. Mail: copy `~/.config/himalaya/config.toml` from the old Mac; its passwords
   live in the Keychain (`security add-generic-password ...`).
7. Grant Accessibility / Input Monitoring when asked: Raycast, Rectangle,
   Hidden Bar. Raycast: import settings (Raycast →
   Settings → Advanced → Import) or sign in for cloud sync.
8. Apps that are not in the `Brewfile` yet. Install by hand, or add a
   `cask "..."` line and run `brew bundle`:
   Claude, cmux, Google Chrome, Anki, AppCleaner, Cap, Zoom, NordVPN,
   Godot, DaVinci Resolve, Microsoft Edge, RØDE Central.
   App Store only (nothing installs these automatically, so no Apple ID
   prompts): Xcode, Developer, Kindle, Microsoft Office, OneDrive, RetroArch.
