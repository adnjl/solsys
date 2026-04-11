local wezterm = require("wezterm")
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 12

config.color_scheme = "Kanagawa Dragon (Gogh)"

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.97
config.window_padding = { left = 8, right = 8, top = 8, bottom = 0 }

bar.apply_to_config(config, { pane = { enabled = false } })

config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250

return config
