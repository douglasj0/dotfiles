-- Pull in the wezterm API
local wezterm =  require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

-- Set color scheme, font, and initial size
config.color_scheme = 'Ubuntu'

-- change window size when increasing/decreasing font size
config.adjust_window_size_when_changing_font_size = true

-- config.font = wezterm.font('Monaco', {weight='Regular', stretch='Normal', style='Normal'})
-- config.font = wezterm.font 'JetBrains Mono'
config.font = wezterm.font("JetBrains Mono", {weight="Bold", stretch="Normal", style="Normal"})
config.font_size = 15.0

-- check size: echo $(tty) TERM=$TERM with ${COLUMNS}x${LINES}
config.initial_cols = 80
config.initial_rows = 24

-- config.scrollback_lines = 8500
config.hide_tab_bar_if_only_one_tab = true

-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10

config.enable_scroll_bar = true

-- Add more configuration here
--

return config
