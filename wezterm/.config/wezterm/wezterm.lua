-- Pull in the wezterm API
local wezterm =  require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()


-- Launching
-- config.default_prog = { "zsh" }
config.automatically_reload_config = true


-- Colorscheme
-- More themes could be found here - https://wezfurlong.org/wezterm/colorschemes/index.html
-- config.color_scheme = 'Ubuntu'
-- config.color_scheme = 'Tokyo Night'
config.color_scheme = 'Dracula'


-- Window
config.bold_brightens_ansi_colors = true
config.initial_cols = 80 -- width
config.initial_rows = 25 -- height
-- check size: echo $(tty) TERM=$TERM with ${COLUMNS}x${LINES}
-- config.text_background_opacity = 0.9
-- config.window_background_opacity = 0.9
-- config.window_decorations = "RESIZE"
-- config.window_padding = {left = 5, right = 5, top = 5, bottom = 5}
config.adjust_window_size_when_changing_font_size = true

-- config.pane_focus_follows_mouse = true
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10
config.quit_when_all_windows_are_closed = false
config.audible_bell = "Disabled"


-- Graphics
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.animation_fps = 60


-- Cursor
config.bypass_mouse_reporting_modifiers = "SHIFT"
-- config.cursor_blink_ease_in = "Linear"
-- config.cursor_blink_rate = 500
-- config.default_cursor_style = "BlinkingBlock"
config.hide_mouse_cursor_when_typing = false


-- Font
config.font = wezterm.font_with_fallback({
    -- disable ligatures for Monaco as it has a `fi` ligature that doesn't look great
    {family="Monaco", harfbuzz_features={"kern", "clig", "liga=0"}},
    "Menlo",
    "Apple Color Emoji"
  }, {weight="Regular"}) -- choices: Bold, Medium

config.font_size = 15.0
config.line_height = 1.0
-- config.cell_width = 0.9
-- config.freetype_render_target = "HorizontalLcd"
-- config.freetype_load_flags = 'NO_HINTING'
-- config.freetype_load_target = 'Light'
-- config.freetype_render_target = 'HorizontalLcd'


-- Hyperlink
-- config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- -- e-mail fulano-ciclano@example.com fulano_ciclano@example.com
-- table.insert(config.hyperlink_rules,{
--   regex = "\\b[A-Z-a-z0-9-_\\.]+@[\\w-]+(\\.[\\w-]+)+\\b",
--   format = "mailto:$0",
-- })


-- Scrolling
config.enable_scroll_bar = true
config.scrollback_lines = 20000000
config.alternate_buffer_wheel_scroll_speed = 5
config.min_scroll_bar_height = "1cell"


-- Tabs
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = true
config.status_update_interval = 1000
config.tab_bar_at_bottom = false
config.tab_max_width = 32
config.use_fancy_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = false


-- Key Mapping
-- https://alexplescan.com/posts/2024/08/10/wezterm/
local function move_pane(key, direction)
  return {
    key = key,
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection(direction),
  }
end

config.leader = { key = 'z', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- ... add these new entries to your config.keys table
  -- Redefine cwd for new windows, but not tabs
  { key = 'n', mods = 'CMD', action = wezterm.action.SpawnCommandInNewWindow { cwd=wezterm.home_dir } },
  { key = 'z', mods = 'LEADER|CTRL', action = wezterm.action.SendKey { key = 'z', mods = 'CTRL' } },
  -- split window (was " and %), switch with CTRL-SHIFT-arrow
  -- maybe add PaneSelect too
  -- https://wezfurlong.org/wezterm/config/lua/keyassignment/PaneSelect.html
  { key='\\', mods='LEADER', action=wezterm.action.SplitHorizontal {domain='CurrentPaneDomain'} },
  { key='-',  mods='LEADER', action=wezterm.action.SplitVertical {domain='CurrentPaneDomain'} },
  { key='Z',  mods='LEADER', action=wezterm.action.TogglePaneZoomState },

  move_pane('DownArrow', 'Down'),
  move_pane('UpArrow', 'Up'),
  move_pane('LeftArrow', 'Left'),
  move_pane('RightArrow', 'Right'),

  -- move tabs
  { key="LeftArrow", mods="CMD", action=wezterm.action {MoveTabRelative=-1} },
  { key="RightArrow", mods="CMD", action=wezterm.action {MoveTabRelative=1} },
}

return config
