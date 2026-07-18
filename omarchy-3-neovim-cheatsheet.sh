#!/bin/bash

# Omarchy Neovim Keybindings Setup
# Adds SUPER N → Neovim Cheatsheet, SUPER E → Neovim

set -e

BINDINGS_FILE="$HOME/.config/hypr/bindings.conf"
CHEATSHEET_SCRIPT="$HOME/.local/bin/neovim-cheatsheet"

# Ensure ~/.local/bin exists and is in PATH
mkdir -p "$HOME/.local/bin"

# Create the neovim cheatsheet script
cat > "$CHEATSHEET_SCRIPT" << 'SCRIPT'
#!/bin/bash
printf '%s\n' \
"--- MODES & FILES ---" \
"i                                           → Insert mode" \
"v                                           → Visual mode (chars)" \
"V                                           → Visual line mode" \
"Esc                                         → Normal mode" \
":w                                          → Save file" \
":q!                                         → Quit without saving" \
":wq                                         → Save and quit" \
"--- NAVIGATING ---" \
"h / j / k / l                               → Left / Down / Up / Right" \
"w / b                                       → Word forward / backward" \
"0 / $                                       → Start / End of line" \
"gg / G                                      → Top / Bottom of file" \
":{num}                                      → Go to line number" \
"Ctrl+d                                      → Page Down" \
"Ctrl+u                                      → Page Up" \
"--- EDITING ---" \
"x                                           → Delete character" \
"dd                                          → Cut current line" \
"yy                                          → Copy current line" \
"p / P                                       → Paste after / before" \
"u                                           → Undo last action" \
"Ctrl+r                                      → Redo last action" \
"o / O                                       → New line below / above" \
"A                                           → Append at end of line" \
".                                           → Repeat last action" \
"--- TEXT OBJECTS ---" \
"ciw                                         → Change inner word" \
"ci\"                                         → Change inside quotes" \
"di(                                         → Delete inside parens" \
"--- SEARCH & REPLACE ---" \
"/{str}                                      → Search forward" \
"n / N                                       → Next / Previous match" \
":%s/{old}/{new}/g                           → Global replace" \
"--- SPLITS & TERMINAL ---" \
":vsplit                                     → Split vertically" \
":split                                      → Split horizontally" \
"Ctrl+w                                      → Switch window split" \
":term                                       → Open terminal" \
| walker --dmenu -p 'Neovim Keybindings' --width 800 --height 600
SCRIPT

chmod +x "$CHEATSHEET_SCRIPT"

# Backup bindings file
cp "$BINDINGS_FILE" "$BINDINGS_FILE.bak.$(date +%s)"

# Remove existing SUPER N and SUPER E bindings if present (lines starting with bind that contain ", N," or ", E,")
sed -i '/^bindd.*SUPER, N,/d' "$BINDINGS_FILE"
sed -i '/^bindd.*SUPER, E,/d' "$BINDINGS_FILE"

# Add new bindings
sed -i '$a\
# Neovim Cheatsheet on SUPER N\
bindd = SUPER, N, Neovim Cheatsheet, exec, neovim-cheatsheet\
# Neovim on SUPER E\
bindd = SUPER, E, Neovim, exec, uwsm-app -- xdg-terminal-exec nvim' "$BINDINGS_FILE"

# Reload hyprland
hyprctl reload

echo "Done! Bindings:"
echo "  SUPER N          → Neovim Cheatsheet"
echo "  SUPER E          → Neovim"
