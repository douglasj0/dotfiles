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

config.keys = {
  -- ... add these new entries to your config.keys table

  -- Theme Cycler
  { key = "t", mods = "ALT", action = wezterm.action_callback(themeCycler) },
  -- Look up name of color scheme you switched to
  { key = "Escape", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}
