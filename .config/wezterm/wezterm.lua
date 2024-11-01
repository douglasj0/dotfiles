-- Notes
-- split pane default shortcuts
--   horizontal ctrl-shift-option-"
--   vertical   ctrl-shift-option-%
-- Pull in the wezterm API
local wezterm =  require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

-- Set theme
-- More themes could be found here - https://wezfurlong.org/wezterm/colorschemes/index.html
-- config.color_scheme = 'Ubuntu'
config.color_scheme = 'Dracula'

-- change window size when increasing/decreasing font size
config.adjust_window_size_when_changing_font_size = true

config.font = wezterm.font_with_fallback({
    -- disable ligatures for Monaco as it has a `fi` ligature that doesn't look great
    {family="Monaco", harfbuzz_features={"kern", "clig", "liga=0"}},
    "Menlo",
    "Apple Color Emoji"
  }, {weight="Regular"}) -- choices: Bold, Medium
config.font_size = 15.0
config.front_end = 'WebGpu'
-- config.cell_width = 0.9

-- config.freetype_render_target = "HorizontalLcd"
-- config.freetype_load_flags = 'NO_HINTING'
-- config.freetype_load_target = 'Light'
-- config.freetype_render_target = 'HorizontalLcd'

-- Set the initial Terminal Size here
-- check size: echo $(tty) TERM=$TERM with ${COLUMNS}x${LINES}
config.initial_cols = 80 -- width
config.initial_rows = 25 -- height

config.scrollback_lines = 10000
config.enable_scroll_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10


-- Add more configuration here
--
config.use_fancy_tab_bar = false
config.quit_when_all_windows_are_closed = false

-- Redifned cwd for new windows
config.keys = {
  { key = 'n', mods = 'CMD', action = wezterm.action.SpawnCommandInNewWindow { cwd=wezterm.home_dir } },
}


return config
