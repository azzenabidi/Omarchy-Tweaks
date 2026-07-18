#!/bin/bash
set -euo pipefail

# =============================================================================
# Omarchy 3 Personal Setup Script
# Generated from Azzen Abidi's config on 2026-07-18
# Run on a fresh Omarchy 3 install to reproduce personal setup
# =============================================================================

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${GREEN}[+]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[x]${NC} $*"; exit 1; }

backup() {
    local file="$1"
    if [[ -f "$file" ]]; then
        cp "$file" "${file}.bak.$(date +%s)"
        log "Backed up $file"
    fi
}

# Check we're running on Arch/omarchy
command -v pacman &>/dev/null || err "This script is for Arch Linux / Omarchy only."

echo ""
echo -e "${BOLD}========================================${NC}"
echo -e "${BOLD}  Omarchy Personal Setup${NC}"
echo -e "${BOLD}========================================${NC}"
echo ""

# =============================================================================
# 1. PACKAGES
# =============================================================================
log "Installing packages..."

# Ensure yay is available for AUR packages
if ! command -v yay &>/dev/null; then
    warn "yay not found. Install it first: omarchy pkg install yay"
    err "yay is required for AUR packages (google-chrome)."
fi

# Official repo packages
PACKAGES=(
    vlc
    vlc-plugins-all
    fuse2
    flatpak
    virtualbox
    virtualbox-host-modules-arch
    transmission-gtk
)

log "Installing official packages: ${PACKAGES[*]}"
yay -S --needed --noconfirm "${PACKAGES[@]}"

# AUR packages
AUR_PACKAGES=(
    google-chrome
    virtualbox-ext-oracle
)

log "Installing AUR packages: ${AUR_PACKAGES[*]}"
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

log "Packages installed."

# =============================================================================
# 2. HYPRLAND KEYBINDINGS
# =============================================================================
log "Configuring keybindings..."

BINDINGS_FILE="$HOME/.config/hypr/bindings.conf"
backup "$BINDINGS_FILE"

cat > "$BINDINGS_FILE" << 'BINDINGS_EOF'
# Application bindings
bindd = SUPER, RETURN, Terminal, exec, uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"
bindd = SUPER ALT, RETURN, Tmux, exec, uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"
bindd = SUPER SHIFT, RETURN, Browser, exec, omarchy-launch-browser
bindd = SUPER SHIFT, F, File manager, exec, uwsm-app -- nautilus --new-window
bindd = SUPER ALT SHIFT, F, File manager (cwd), exec, uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"
bindd = SUPER SHIFT, B, Browser, exec, omarchy-launch-browser
bindd = SUPER SHIFT ALT, B, Browser (private), exec, omarchy-launch-browser --private
bindd = SUPER SHIFT, M, Music, exec, omarchy-launch-or-focus spotify
bindd = SUPER SHIFT ALT, M, Music TUI, exec, omarchy-launch-or-focus-tui cliamp
# Unbind SUPER SHIFT N from Editor (rebound to Notion)
unbind = SUPER SHIFT, N
bindd = SUPER SHIFT, N, Notion, exec, omarchy-launch-webapp "https://www.notion.so"
bindd = SUPER, N, Neovim, exec, uwsm-app -- xdg-terminal-exec nvim
bindd = SUPER SHIFT, D, Docker, exec, omarchy-launch-tui lazydocker
# Unbind SUPER SHIFT G from Signal (rebound to Gemini)
unbind = SUPER SHIFT, G
bindd = SUPER SHIFT, G, Gemini, exec, omarchy-launch-webapp "https://gemini.google.com"
# Unbind SUPER SHIFT O from Obsidian (rebound to OpenCode)
unbind = SUPER SHIFT, O
bindd = SUPER SHIFT, O, OpenCode, exec, uwsm-app -- xdg-terminal-exec --dir="/home/azzen" opencode
bindd = SUPER SHIFT, W, Typora, exec, uwsm-app -- typora --enable-wayland-ime
bindd = SUPER SHIFT, SLASH, Passwords, exec, uwsm-app -- 1password

# If your web app url contains #, type it as ## to prevent hyprland treating it as a comment
bindd = SUPER SHIFT, A, ChatGPT, exec, omarchy-launch-webapp "https://chatgpt.com"
bindd = SUPER SHIFT ALT, A, Grok, exec, omarchy-launch-webapp "https://grok.com"
bindd = SUPER SHIFT, C, Calendar, exec, omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"
bindd = SUPER SHIFT, E, Email, exec, omarchy-launch-webapp "https://app.hey.com"
bindd = SUPER SHIFT, Y, YouTube, exec, omarchy-launch-webapp "https://youtube.com/"
bindd = SUPER SHIFT ALT, G, WhatsApp, exec, omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"
bindd = SUPER SHIFT CTRL, G, Google Messages, exec, omarchy-launch-or-focus-webapp "Google Messages" "https://messages.google.com/web/conversations"
# Unbind SUPER SHIFT P from Google Photos (rebound to ShadowPC)
unbind = SUPER SHIFT, P
bindd = SUPER SHIFT, P, ShadowPC, exec, ELECTRON_OZONE_PLATFORM_HINT=x11 /home/azzen/Downloads/ShadowPC.AppImage
bindd = SUPER ALT, G, GeForce NOW, exec, flatpak run com.nvidia.geforcenow
bindd = SUPER ALT, S, Steam, exec, uwsm-app -- steam
bindd = SUPER SHIFT, X, X, exec, omarchy-launch-webapp "https://x.com/"
bindd = SUPER SHIFT ALT, X, X Post, exec, omarchy-launch-webapp "https://x.com/compose/post"

# Override close window binding: Super Q instead of Super W
unbind = SUPER, W
bindd = SUPER, Q, Close window, killactive,
BINDINGS_EOF

log "Keybindings configured."

# =============================================================================
# 3. MONITORS
# =============================================================================
log "Configuring monitor settings..."

MONITORS_FILE="$HOME/.config/hypr/monitors.conf"
backup "$MONITORS_FILE"

cat > "$MONITORS_FILE" << 'MONITORS_EOF'
# See https://wiki.hypr.land/Configuring/Basics/Monitors/
# List current monitors and resolutions possible: hyprctl monitors
# Format: monitor = [port], resolution, position, scale

# 1x setup for low-resolution displays like 1080p or 1440p
# Or for ultrawide monitors like 34" 3440x1440 or 49" 5120x1440
env = GDK_SCALE,1
monitor=,preferred,auto,1
MONITORS_EOF

log "Monitor settings configured."

# =============================================================================
# 4. INPUT (KEYBOARD LAYOUTS)
# =============================================================================
log "Configuring keyboard layouts..."

INPUT_FILE="$HOME/.config/hypr/input.conf"
backup "$INPUT_FILE"

cat > "$INPUT_FILE" << 'INPUT_EOF'
# Control your input devices
# See https://wiki.hypr.land/Configuring/Basics/Variables/#input
input {
  # French + Arabic keyboard layout, switch with Alt+Shift
  kb_layout = fr, ara
  kb_options = grp:alt_shift_toggle

  # Change speed of keyboard repeat
  repeat_rate = 40
  repeat_delay = 250

  # Start with numlock on by default
  numlock_by_default = true

  touchpad {
    # Use two-finger clicks for right-click instead of lower-right corner
    clickfinger_behavior = true

    # Control the speed of your scrolling
    scroll_factor = 0.4
  }
}

# Scroll nicely in the terminal
windowrule = match:class (Alacritty|kitty|foot), scroll_touchpad 1.5
windowrule = match:class com.mitchellh.ghostty, scroll_touchpad 0.2
INPUT_EOF

log "Keyboard layouts configured."

# =============================================================================
# 5. WAYBAR CONFIG
# =============================================================================
log "Configuring waybar..."

WAYBAR_CONFIG="$HOME/.config/waybar/config.jsonc"
backup "$WAYBAR_CONFIG"

cat > "$WAYBAR_CONFIG" << 'WAYBAR_EOF'
{
  "reload_style_on_change": true,
  "layer": "top",
  "position": "top",
  "spacing": 0,
  "height": 26,
  "modules-left": ["custom/omarchy", "hyprland/workspaces"],
  "modules-center": ["clock", "custom/weather", "custom/update", "custom/voxtype", "custom/screenrecording-indicator", "custom/idle-indicator", "custom/notification-silencing-indicator"],
  "modules-right": [
    "group/tray-expander",
    "hyprland/language",
    "bluetooth",
    "network",
    "pulseaudio",
    "cpu",
    "battery"
  ],
  "hyprland/workspaces": {
    "on-click": "activate",
    "format": "{icon}",
    "format-icons": {
      "default": "",
      "1": "1",
      "2": "2",
      "3": "3",
      "4": "4",
      "5": "5",
      "6": "6",
      "7": "7",
      "8": "8",
      "9": "9",
      "10": "0",
      "active": "󱓻"
    },
    "persistent-workspaces": {
      "1": [],
      "2": [],
      "3": [],
      "4": [],
      "5": []
    }
  },
  "custom/omarchy": {
    "format": "<span font='omarchy'>\ue900</span>",
    "on-click": "omarchy-menu",
    "on-click-right": "xdg-terminal-exec",
    "tooltip-format": "Omarchy Menu\n\nSuper + Alt + Space"
  },
  "custom/update": {
    "format": "",
    "exec": "omarchy-update-available",
    "on-click": "omarchy-launch-floating-terminal-with-presentation omarchy-update",
    "tooltip-format": "Omarchy update available",
    "signal": 7,
    "interval": 21600
  },

  "cpu": {
    "interval": 5,
    "format": "󰍛",
    "on-click": "omarchy-launch-or-focus-tui btop",
    "on-click-right": "alacritty"
  },
  "clock": {
    "format": "{:L%A %d %B %H:%M}",
    "format-alt": "{:L%d %B W%V %Y}",
    "tooltip": false,
    "on-click-right": "omarchy-launch-floating-terminal-with-presentation omarchy-tz-select"
  },
  "custom/weather": {
    "exec": "$OMARCHY_PATH/default/waybar/weather.sh",
    "return-type": "json",
    "interval": 60,
    "tooltip": false,
    "on-click": "notify-send -u low \"$(omarchy-weather-status)\""
  },
  "network": {
    "format-icons": ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"],
    "format": "{icon}",
    "format-wifi": "{icon}",
    "format-ethernet": "󰀂",
    "format-disconnected": "󰤮",
    "tooltip-format-wifi": "{essid} ({frequency} GHz)",
    "tooltip-format-ethernet": "Connected",
    "tooltip-format-disconnected": "Disconnected",
    "interval": 3,
    "spacing": 1,
    "on-click": "omarchy-launch-wifi"
  },
  "battery": {
    "format": "{capacity}% {icon}",
    "format-discharging": "{icon}",
    "format-charging": "{icon}",
    "format-plugged": "",
    "format-icons": {
      "charging": ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
      "default": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    },
    "format-full": "󰂅",
    "tooltip-format-discharging": "{power:>1.0f}W↓ {capacity}%",
    "tooltip-format-charging": "{power:>1.0f}W↑ {capacity}%",
    "interval": 5,
    "on-click": "omarchy-menu power",
    "on-click-right": "notify-send -u low \"$(omarchy-battery-status)\"",
    "states": {
      "warning": 20,
      "critical": 10
    }
  },
  "bluetooth": {
    "format": "",
    "format-off": "󰂲",
    "format-disabled": "󰂲",
    "format-connected": "󰂱",
    "format-no-controller": "",
    "tooltip-format": "Devices connected: {num_connections}",
    "on-click": "omarchy-launch-bluetooth"
  },
  "hyprland/language": {
    "format": "{short}",
    "format-long": "{long}",
    "on-click": "hyprctl dispatch xkbkblayout next",
    "tooltip-format": "Keyboard: {long}"
  },
  "pulseaudio": {
    "format": "{icon}",
    "on-click": "omarchy-launch-audio",
    "on-click-right": "pamixer -t",
    "tooltip-format": "Playing at {volume}%",
    "scroll-step": 5,
    "format-muted": "",
    "format-icons": {
      "headphone": "",
      "headset": "",
      "default": ["", "", ""]
    }
  },
  "group/tray-expander": {
    "orientation": "inherit",
    "drawer": {
      "transition-duration": 600,
      "children-class": "tray-group-item"
    },
    "modules": ["custom/expand-icon", "tray"]
  },
  "custom/expand-icon": {
    "format": "",
    "tooltip": false,
    "on-scroll-up": "",
    "on-scroll-down": "",
    "on-scroll-left": "",
    "on-scroll-right": ""
  },
  "custom/screenrecording-indicator": {
    "on-click": "omarchy-capture-screenrecording",
    "exec": "$OMARCHY_PATH/default/waybar/indicators/screen-recording.sh",
    "signal": 8,
    "return-type": "json"
  },
  "custom/idle-indicator": {
    "on-click": "omarchy-toggle-idle",
    "exec": "$OMARCHY_PATH/default/waybar/indicators/idle.sh",
    "signal": 9,
    "return-type": "json"
  },
  "custom/notification-silencing-indicator": {
    "on-click": "omarchy-toggle-notification-silencing",
    "exec": "$OMARCHY_PATH/default/waybar/indicators/notification-silencing.sh",
    "signal": 10,
    "return-type": "json"
  },
  "custom/voxtype": {
    "exec": "omarchy-voxtype-status",
    "return-type": "json",
    "format": "{icon}",
    "format-icons": {
      "idle": "",
      "recording": "󰍬",
      "transcribing": "󰔟"
    },
    "tooltip": true,
    "on-click-right": "omarchy-voxtype-config",
    "on-click": "omarchy-voxtype-model"
  },
  "tray": {
    "icon-size": 12,
    "spacing": 17
  }
}
WAYBAR_EOF

log "Waybar config written."

# =============================================================================
# 6. WAYBAR STYLES
# =============================================================================
log "Configuring waybar styles..."

WAYBAR_STYLE="$HOME/.config/waybar/style.css"
backup "$WAYBAR_STYLE"

cat > "$WAYBAR_STYLE" << 'WAYBAR_CSS_EOF'
@import "../omarchy/current/theme/waybar.css";

* {
  background-color: @background;
  color: @foreground;

  border: none;
  border-radius: 0;
  min-height: 0;
  font-family: 'JetBrainsMono Nerd Font';
  font-size: 12px;
}

.modules-left {
  margin-left: 8px;
}

.modules-right {
  margin-right: 8px;
}

#workspaces button {
  all: initial;
  padding: 0 6px;
  margin: 0 1.5px;
  min-width: 9px;
}

#workspaces button.empty {
  opacity: 0.5;
}

#cpu,
#battery,
#pulseaudio,
#custom-omarchy,
#custom-update {
  min-width: 12px;
  margin: 0 7.5px;
}

#tray {
  margin-right: 16px;
}

#bluetooth {
  margin-right: 17px;
}

#language {
  min-width: 12px;
  margin: 0 7.5px;
}

#network {
  margin-right: 13px;
}

#custom-expand-icon {
  margin-right: 18px;
}

tooltip {
  padding: 2px;
}

#custom-update {
  font-size: 10px;
}

#clock {
  margin-left: 8.75px;
}

#custom-weather {
  margin-left: 7.5px;
  margin-right: 7.5px;
}

#custom-weather.unavailable {
  min-width: 0;
  margin: 0;
  padding: 0;
}

.hidden {
  opacity: 0;
}

#custom-screenrecording-indicator,
#custom-idle-indicator,
#custom-notification-silencing-indicator {
  min-width: 12px;
  margin-left: 5px;
  margin-right: 0;
  font-size: 10px;
  padding-bottom: 1px;
}

#custom-screenrecording-indicator.active {
  color: #a55555;
}

#custom-idle-indicator.active,
#custom-notification-silencing-indicator.active {
  color: #a55555;
}

#custom-voxtype {
  min-width: 12px;
  margin: 0 0 0 7.5px;
}

#custom-voxtype.recording {
  color: #a55555;
}
WAYBAR_CSS_EOF

log "Waybar styles written."

# =============================================================================
# 7. ALACRITTY
# =============================================================================
log "Configuring Alacritty..."

ALACRITTY_FILE="$HOME/.config/alacritty/alacritty.toml"
backup "$ALACRITTY_FILE"

cat > "$ALACRITTY_FILE" << 'ALACRITTY_EOF'
general.import = [ "~/.config/omarchy/current/theme/alacritty.toml" ]

[env]
TERM = "xterm-256color"

[terminal]
osc52 = "CopyPaste"

[font]
normal = { family = "JetBrainsMono Nerd Font" }
bold = { family = "JetBrainsMono Nerd Font" }
italic = { family = "JetBrainsMono Nerd Font" }
size = 9

[window]
padding.x = 14
padding.y = 14
decorations = "None"

[keyboard]
bindings = [
{ key = "Insert", mods = "Shift", action = "Paste" },
{ key = "Insert", mods = "Control", action = "Copy" },
# Send Shift+Return as CSI-u so TUIs can distinguish it from Return without treating it as Alt+Return.
{ key = "Return", mods = "Shift", chars = "\u001B[13;2u" },
# Legacy encoding sends Alt+Shift+Return the same as Alt+Return; send CSI-u so tmux can match M-S-Enter.
{ key = "Return", mods = "Alt|Shift", chars = "\u001B[13;4u" }
]
ALACRITTY_EOF

log "Alacritty configured."

# =============================================================================
# 8. FOOT
# =============================================================================
log "Configuring Foot..."

FOOT_FILE="$HOME/.config/foot/foot.ini"
backup "$FOOT_FILE"

cat > "$FOOT_FILE" << 'FOOT_EOF'
[main]
include=~/.config/omarchy/current/theme/foot.ini
term=xterm-256color
font=JetBrainsMono Nerd Font:size=9
pad=14x14
initial-window-mode=windowed
workers=0

[scrollback]
lines=10000

[cursor]
style=block
blink=no

[key-bindings]
clipboard-copy=Control+Insert
primary-paste=none
clipboard-paste=Shift+Insert
\n[text-bindings]
FOOT_EOF

log "Foot configured."

# =============================================================================
# 9. GIT CONFIG
# =============================================================================
log "Configuring git..."

GIT_FILE="$HOME/.config/git/config"
backup "$GIT_FILE"

# Only add [user] section if not already present
if ! grep -q '\[user\]' "$GIT_FILE" 2>/dev/null; then
    cat >> "$GIT_FILE" << 'GIT_USER_EOF'

[user]
	name = Azzen Abidi
	email = azzen.abidi@gmail.com
GIT_USER_EOF
    log "Git user identity added."
else
    warn "Git [user] section already exists, skipping."
fi

# =============================================================================
# 10. RESTART SERVICES
# =============================================================================
log "Restarting services..."

omarchy restart waybar 2>/dev/null && log "Waybar restarted." || warn "Could not restart waybar (run manually: omarchy restart waybar)"

hyprctl reload 2>/dev/null && log "Hyprland reloaded." || warn "Could not reload Hyprland (run manually: hyprctl reload)"

echo ""
echo -e "${BOLD}========================================${NC}"
echo -e "${GREEN}${BOLD}  Setup complete!${NC}"
echo -e "${BOLD}========================================${NC}"
echo ""
echo "Installed packages: vlc, google-chrome, steam, flatpak, virtualbox,"
echo "  transmission-gtk, fuse2"
echo ""
echo "Applied configs:"
echo "  - Keybindings (Notion, Neovim, Gemini, OpenCode, ShadowPC, Steam, GFN)"
echo "  - Display scale 1x (1080p/1440p/ultrawide)"
echo "  - FR+ARA keyboard layout with Alt+Shift toggle"
echo "  - Waybar: language module + date in clock"
echo "  - Alacritty & Foot: cleaned up font/bindings"
echo "  - Git: user identity set"
echo ""
echo "Note: ShadowPC AppImage expected at ~/Downloads/ShadowPC.AppImage"
echo "      Run 'hyprctl reload' if keybinds don't take effect."
