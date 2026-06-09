local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- set default color theme
-- config.color_scheme = 'Ubuntu'

-- Keeps the application alive when no windows are open
config.quit_when_all_windows_are_closed = false

-- ==========================================================================
-- TYPOGRAPHY & TEXT
-- ==========================================================================
config.font = wezterm.font('Monaco')
config.font_size = 16.0

-- ==========================================================================
-- GHOSTTY STYLING: BACKGROUND OPACITY & BLUR
-- ==========================================================================
config.window_background_opacity = 0.95
config.macos_window_background_blur = 40 -- Apple-specific background blur depth

-- ==========================================================================
-- WINDOW LAYOUT & INITIAL DIMENSIONS
-- ==========================================================================
config.window_decorations = "TITLE | RESIZE"
config.initial_cols = 80
config.initial_rows = 24

-- Compact & Balanced Padding: Maps '0 1.5' (Kitty scale) to WezTerm pixel spacing
config.window_padding = {
  left = 6,
  right = 6,
  top = 4,
  bottom = 4,
}

-- ==========================================================================
-- CURSOR SETTINGS
-- ==========================================================================
config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 0

-- ==========================================================================
-- MOUSE & SCROLLBACK
-- ==========================================================================
config.hide_mouse_cursor_when_typing = true
config.scrollback_lines = 80000

-- ==========================================================================
-- MACOS SPECIFIC CONFIGURATIONS
-- ==========================================================================
config.send_composed_key_when_left_alt_is_pressed = false   -- Treats Left Option as Alt
config.send_composed_key_when_right_alt_is_pressed = false  -- Treats Right Option as Alt
config.window_close_confirmation = 'NeverPrompt'

-- ==========================================================================
-- PERFORMANCE & HIGH REFRESH RATE (FPS)
-- ==========================================================================
config.front_end = "WebGpu"
config.max_fps = 120
config.animation_fps = 120

-- ==========================================================================
-- TAB BAR LAYOUT & BASIC STYLING
-- ==========================================================================
config.tab_bar_at_bottom = false -- Forces tab bar to the top
config.use_fancy_tab_bar = false -- Gives you a clean, flat, minimalist layout
config.hide_tab_bar_if_only_one_tab = true -- Only shows bar if 2 or more tabs are open

-- ==========================================================================
-- CUSTOM KEYBINDS
-- ==========================================================================
config.keys = {
  -- map shift+ctrl+left_bracket previous_tab
  {
    key = '[',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  -- map shift+ctrl+right_bracket next_tab
  {
    key = ']',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(1),
  },
  -- Split horizontally (CMD + d)
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Split vertically (CMD + SHIFT + d)
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Cycle sequentially between split window panes
  {
    key = '[',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Next',
  },
  {
    key = ']',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Prev',
  },
}

-- ==========================================================================
-- SWITCH REMOTE THEME
-- ==========================================================================
-- 🌘 Dark / Monochromatic: Deep Space, Nightfly, Tokyo Night, Carbonfox
-- 🪵 Retro / Warm: Gruvbox Dark, Everforest Dark Hard, Catppuccin Macchiato
-- 🧪 High Contrast (Great for Production Servers): Batman, Dracula, Monokai, OneHalfDark
-- ❄️ Cool / Pastel: Nord, Aura, Oceanic Next
-- ctrl-shift-p command pallet

-- Your standard, everyday theme
-- config.color_scheme = 'Default'
config.color_scheme = 'Ubuntu'

-- host patterns and target themes
-- ~/.config/wezterm/hosts_private.lua
-- local host_themes = {
--   db   = 'Batman',
--   web  = 'Dracula',
--   test = 'Gruvbox Dark',
--   prod = 'Nord',
-- }

local has_private_hosts, host_themes = pcall(require, 'hosts_private')
if not has_private_hosts then
  -- Fallback to empty mappings if the file isn't found
  host_themes = {}
end

wezterm.on('update-status', function(window, pane)
  local process_name = pane:get_foreground_process_name() or ""

  local info = pane:get_foreground_process_info()
  local cmd_line = ""
  if info then
    cmd_line = table.concat(info.argv, " ")
  end

  local target_theme = nil

  -- for ssh check the command line against list_themes
  if string.find(process_name, 'ssh') then
    for pattern, theme in pairs(host_themes) do
      if string.find(cmd_line, pattern) then
        target_theme = theme
        break -- Stop checking once we find a match
      end
    end
  end

  -- apply custom theme if matched, else revert to default
  if target_theme then
    window:set_config_overrides({ color_scheme = target_theme })
  else
    window:set_config_overrides({})
  end
end)

return config
