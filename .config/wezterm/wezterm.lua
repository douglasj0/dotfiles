-- Pull in the wezterm API
local wezterm =  require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

-- Set color scheme, font, and initial size
-- config.color_scheme = 'Ubuntu'
config.color_scheme = 'Dracula'

-- change window size when increasing/decreasing font size
config.adjust_window_size_when_changing_font_size = true

config.font = wezterm.font_with_fallback({
    -- disable ligatures for Monaco as it has a `fi` ligature that doesn't look great
    {family="Monaco", harfbuzz_features={"kern", "clig", "liga=0"}},
    "Menlo",
    "Apple Color Emoji"
  }, {weight="Regular"})
config.font_size = 15.0

-- check size: echo $(tty) TERM=$TERM with ${COLUMNS}x${LINES}
config.initial_cols = 80
config.initial_rows = 25

-- config.scrollback_lines = 8500
config.scrollback_lines = 10000
config.enable_scroll_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10


-- Add more configuration here
--

return config
