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


---cycle through builtin dark schemes in dark mode,
---and through light schemes in light mode
-- https://github.com/wez/wezterm/discussions/3426
local function themeCycler(window, _)
	local allSchemes = wezterm.color.get_builtin_schemes()
	local currentMode = wezterm.gui.get_appearance()
	local currentScheme = window:effective_config().color_scheme
	local darkSchemes = {}
	local lightSchemes = {}

	for name, scheme in pairs(allSchemes) do
		if scheme.background then
			local bg = wezterm.color.parse(scheme.background) -- parse into a color object
			---@diagnostic disable-next-line: unused-local
			local h, s, l, a = bg:hsla() -- and extract HSLA information
			if l < 0.4 then
				table.insert(darkSchemes, name)
			else
				table.insert(lightSchemes, name)
			end
		end
	end
	local schemesToSearch = currentMode:find("Dark") and darkSchemes or lightSchemes

	for i = 1, #schemesToSearch, 1 do
		if schemesToSearch[i] == currentScheme then
			local overrides = window:get_config_overrides() or {}
			overrides.color_scheme = schemesToSearch[i+1]
			wezterm.log_info("Switched to: " .. schemesToSearch[i+1])
			window:set_config_overrides(overrides)
			return
		end
	end
end


-- Add more configuration here
--
config.use_fancy_tab_bar = false
config.quit_when_all_windows_are_closed = false

-- leader key
-- https://alexplescan.com/posts/2024/08/10/wezterm/
config.leader = { key = 'z', mods = 'CTRL', timeout_milliseconds = 1000 }

local function move_pane(key, direction)
  return {
    key = key,
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection(direction),
  }
end

config.keys = {
  -- ... add these new entries to your config.keys table

  -- Theme Cycler
  { key = "t", mods = "ALT", action = wezterm.action_callback(themeCycler) },
  -- Look up name of color scheme you switched to
  { key = "Escape", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },

  -- Redefine cwd for new windows, but not tabs
  { key = 'n', mods = 'CMD', action = wezterm.action.SpawnCommandInNewWindow { cwd=wezterm.home_dir } },
  {
    key = 'z',
    -- When we're in leader mode _and_ CTRL + A is pressed...
    mods = 'LEADER|CTRL',
    -- Actually send CTRL + A key to the terminal
    action = wezterm.action.SendKey { key = 'z', mods = 'CTRL' },
  },
  {
    -- I'm used to tmux bindings, so am using the quotes (") key to
    -- split horizontally, and the percent (%) key to split vertically.
    key = '"',
    -- Note that instead of a key modifier mapped to a key on your keyboard
    -- like CTRL or ALT, we can use the LEADER modifier instead.
    -- This means that this binding will be invoked when you press the leader
    -- (CTRL + A), quickly followed by quotes (").
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '%',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  move_pane('DownArrow', 'Down'),
  move_pane('UpArrow', 'Up'),
  move_pane('LeftArrow', 'Left'),
  move_pane('RightArrow', 'Right'),
}

return config
