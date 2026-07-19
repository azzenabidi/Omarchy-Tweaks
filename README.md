# Omarchy-Tweaks

Personal Omarchy tweaks and helper scripts grouped by the Omarchy release they target.

## Structure

- [omarchy-3](omarchy-3): scripts for Omarchy 3.
- [omarchy-4](omarchy-4): scripts for Omarchy 4 Alpha 

## Scripts

### Omarchy 3

#### [omarchy-3/omarchy-3-setup.sh](omarchy-3/omarchy-3-setup.sh)

Purpose:
- Apply a personal Omarchy 3 setup on a fresh install.
- Install packages from the official repos and AUR.
- Configure Hyprland keybindings, monitors, input layouts, Waybar, Alacritty, Foot, and Git.
- Restart Waybar and reload Hyprland at the end.

Usage:
1. Make the script executable: `chmod +x omarchy-3/omarchy-3-setup.sh`
2. Run it on a fresh Omarchy 3 system: `./omarchy-3/omarchy-3-setup.sh`

Notes:
- This script expects Arch/Omarchy with `pacman` available.
- It also requires `yay` for AUR installs (`google-chrome`, `virtualbox-ext-oracle`).
- ShadowPC is expected at `~/Downloads/ShadowPC.AppImage` for the custom keybinding.
- If `hyprctl reload` or `omarchy restart waybar` fail, run them manually.

Before you run:
- Ensure `yay` is installed and working.
- Place `ShadowPC.AppImage` in `~/Downloads` if you want the ShadowPC keybinding to work.
- Verify `~/.local/bin` is in your `PATH` for the Neovim cheatsheet helper.

Installed packages:
- Official repos: `vlc`, `vlc-plugins-all`, `fuse2`, `flatpak`, `virtualbox`, `virtualbox-host-modules-arch`, `transmission-gtk`
- AUR: `google-chrome`, `virtualbox-ext-oracle`

Omarchy defaults changed:
- Hyprland keybindings: custom app and webapp bindings, plus remapped/unbound default bindings for `SUPER SHIFT N/G/O/P/W` and `SUPER W`.
- Hyprland monitors: sets a preferred/auto monitor layout with 1x scale for 1080p/1440p/ultrawide displays.
- Hyprland input: custom keyboard layout `fr, ara` with `Alt+Shift` toggle, repeat timing, numlock enabled, touchpad settings, and terminal scroll rules.
- Waybar: custom `config.jsonc` modules, layout, language module, clock format, update/weather/notification indicators, and custom CSS styling.
- Alacritty: custom terminal config importing Omarchy theme, font, padding, decorations, and clipboard/Enter-key bindings.
- Foot: custom terminal config importing theme, font, scrollback, cursor style, and clipboard key bindings.
- Git: adds a user identity section if missing.

#### [omarchy-3/omarchy-3-neovim-cheatsheet.sh](omarchy-3/omarchy-3-neovim-cheatsheet.sh)

Purpose:
- Create a small Neovim cheatsheet helper script at `~/.local/bin/neovim-cheatsheet`.
- Add Hyprland bindings for quick access to the cheatsheet and Neovim.

Usage:
1. Make the script executable: `chmod +x omarchy-3/omarchy-3-neovim-cheatsheet.sh`
2. Run it on Omarchy 3: `./omarchy-3/omarchy-3-neovim-cheatsheet.sh`

Result:
- Adds `SUPER N` to show the Neovim cheatsheet.
- Adds `SUPER E` to launch Neovim.
- Reloads Hyprland after updating the bindings.

### Omarchy 4

This script was taken from [the official repo](https://github.com/basecamp/omarchy)

Purpose:
- Upgrade from omarchy 3 to omarchy 4 alpha
- Support the official Omarchy upgrade workflow with `--yes`, `--reboot`, `--dev`, and channel overrides.

Usage:
1. Run it directly at your own risk.`
2. Follow the official Omarchy Discord Server  for updates.

## Summary

- [omarchy-3/omarchy-3-setup.sh](omarchy-3/omarchy-3-setup.sh): full personal Omarchy 3 install/config bootstrap.
- [omarchy-3/omarchy-3-neovim-cheatsheet.sh](omarchy-3/omarchy-3-neovim-cheatsheet.sh): Neovim cheatsheet and keybinding helper for Hyprland.
- [omarchy-4/omarchy-upgrade-to-quattro](omarchy-4/omarchy-upgrade-to-quattro): upgrade helper for Omarchy 4 / Quattro.
