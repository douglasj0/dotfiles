local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Mimic Ubuntu's standard terminal color theme from your "ubuntu-theme.conf"
config.color_scheme = 'Ubuntu' 

-- ==========================================================================
-- TYPOGRAPHY & TEXT
-- ==========================================================================
config.font = wezterm.font('Monaco')
config.font_size = 16.0

-- ==========================================================================
-- GHOSTTY STYLING: BACKGROUND OPACITY & BLUR
-- ==========================================================================
config.window_background_opacity = 0.85
config.macos_window_background_blur = 40 -- Apple-specific background blur depth

-- ==========================================================================
-- WINDOW LAYOUT & INITIAL DIMENSIONS
-- ==========================================================================
config.window_decorations = "TITLE | RESIZE" -- Restores the standard title bar
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
config.default_cursor_style = 'SteadyBlock' -- Replaces BlinkingBlock to disable animations
config.cursor_blink_rate = 0               -- Ensures blinking is completely turned off

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
-- CUSTOM KEYBINDS (Including your new split window layouts)
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
-- KITTY-STYLE DYNAMIC TAB TITLES WITH FIX FOR FALSE ACTIVITY INDICATORS
-- ==========================================================================
local seen_tabs = {}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local active_pane = tab.active_pane
  local title = active_pane.title
  
  -- Clean up path strings to just show the base process name
  if active_pane.foreground_process_name and #active_pane.foreground_process_name > 0 then
    title = active_pane.foreground_process_name:gsub("(.*[/\\])", "")
  end

  -- Track true tab state transitions
  if tab.is_active then
    seen_tabs[tab.tab_id] = true
  end

  -- Filter for real background data updates
  local has_unseen_output = false
  if seen_tabs[tab.tab_id] then
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then
        has_unseen_output = true
        break
      end
    end
  end

  local activity_symbol = ""
  if has_unseen_output and not tab.is_active then
    activity_symbol = "• " 
  end

  local tab_index = tab.tab_index + 1 
  local display_text = string.format(" %d: %s%s ", tab_index, activity_symbol, title)

  -- Render Colors
  if tab.is_active then
    return {
      { Attribute = { Intensity = 'Bold' } },
      { Background = { Color = '#333333' } }, 
      { Foreground = { Color = '#ffffff' } },
      { Text = display_text },
    }
  elseif has_unseen_output then
    return {
      { Attribute = { Intensity = 'Bold' } },
      { Background = { Color = '#4a154b' } }, 
      { Foreground = { Color = '#ff5555' } }, 
      { Text = display_text },
    }
  else
    return {
      { Background = { Color = '#1a1a1a' } }, 
      { Foreground = { Color = '#888888' } },
      { Text = display_text },
    }
  end
end)

return config

