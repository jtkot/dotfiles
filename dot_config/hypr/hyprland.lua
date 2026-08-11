-- VARIABLES
local terminal = "ghostty"
local main_mod = "CTRL + SUPER + "

local function startApp(cmd)
	return hl.dsp.exec_cmd("uwsm app -- " .. cmd)
end

local function startService(cmd)
	return hl.exec_cmd("uwsm app -t service -s b -- " .. cmd, {})
end

-- MONITORS
hl.monitor({
	output = "",
	mode = "highrr",
	position = "auto",
	scale = 1.25,
	vrr = 3,
	icc = "/home/jan/Library/ColorSync/Profiles/S2725QC_6500.icc",
})


-- SERVICES
hl.on("hyprland.start", function()
	startService("elephant")
	startService("walker --gapplication-service")
	startService("hypridle")
	startService("hyprpolkitagent")
	startService("qs")
end)


-- PERMISSIONS
hl.config({
	ecosystem = {
		enforce_permissions = true,
	},
})

hl.permission({ binary = "^/nix/store/.*-grim-.*/bin/grim$", type = "screencopy", mode = "allow" })
hl.permission({ binary = "^/nix/store/.*-hyprlock-.*/bin/hyprlock$", type = "screencopy", mode = "allow" })


-- LOOK AND FEEL
hl.config({
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
	general = {
		border_size = 0,
		gaps_in = 0,
		gaps_out = 0,
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		blur = {
			enabled = true,
			size = 8,
			passes = 3,
		},
		dim_inactive = true,
		dim_strength = 0.1,
		rounding = 0,
		shadow = {
			enabled = true,
			range = 150,
			render_power = 2,
			color = "rgba(00000040)",
			scale = 0.95,
			offset = { 0, 20 },
		},
	},
	xwayland = {
		force_zero_scaling = true,
		use_nearest_neighbor = false,
	},
	animations = {
		enabled = true,
	},
	cursor = {
		no_warps = true,
		no_hardware_cursors = false,
	},
	dwindle = {
		preserve_split = true
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		background_color = 0x1f1f24,
	}
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "fade", enabled = false })
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "workspaces", enabled = false })

-- INPUT
hl.config({
	input = {
		kb_layout = "pl",
		follow_mouse = 0,
		sensitivity = 0.675,
		accel_profile = "flat",
	}
})


-- KEYBINDINGS
hl.bind("CTRL + Q", hl.dsp.window.close())
hl.bind("CTRL + Space", startApp("walker"))
hl.bind("CTRL + SHIFT + 3", startApp("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind("CTRL + SHIFT + 5", startApp("grim -g \"$(slurp)\""))
hl.bind(main_mod .. "Return", startApp(terminal))
hl.bind(main_mod .. "Q", hl.dsp.exec_cmd("loginctl lock-session"))

hl.bind(main_mod .. "L", hl.dsp.focus({ direction = "r" }))
hl.bind(main_mod .. "H", hl.dsp.focus({ direction = "l" }))
hl.bind(main_mod .. "K", hl.dsp.focus({ direction = "u" }))
hl.bind(main_mod .. "J", hl.dsp.focus({ direction = "d" }))

hl.bind(main_mod .. "1", hl.dsp.focus({ workspace = 1 }))
hl.bind(main_mod .. "2", hl.dsp.focus({ workspace = 2 }))
hl.bind(main_mod .. "3", hl.dsp.focus({ workspace = 3 }))
hl.bind(main_mod .. "4", hl.dsp.focus({ workspace = 4 }))
hl.bind(main_mod .. "5", hl.dsp.focus({ workspace = 5 }))
hl.bind(main_mod .. "6", hl.dsp.focus({ workspace = 6 }))
hl.bind(main_mod .. "7", hl.dsp.focus({ workspace = 7 }))
hl.bind(main_mod .. "8", hl.dsp.focus({ workspace = 8 }))
hl.bind(main_mod .. "9", hl.dsp.focus({ workspace = 9 }))
hl.bind(main_mod .. "0", hl.dsp.focus({ workspace = 10 }))
hl.bind(main_mod .. "SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(main_mod .. "SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(main_mod .. "SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(main_mod .. "SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(main_mod .. "SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(main_mod .. "SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(main_mod .. "SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(main_mod .. "SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(main_mod .. "SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(main_mod .. "SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(main_mod .. "Left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(main_mod .. "Right", hl.dsp.focus({ workspace = "+1" }))
hl.bind(main_mod .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main_mod .. "mouse:272", hl.dsp.window.drag())
hl.bind(main_mod .. "mouse:273", hl.dsp.window.resize())

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"))
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("ddcutil setvcp 10 + 5"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ddcutil setvcp 10 - 5"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

hl.window_rule({
	name = "fix-tooltips",
	match = { class = "UnrealEditor", float = true },
	no_initial_focus = true,
})

hl.window_rule({
	name = "floating-sushi",
	match = { class = "org.gnome.NautilusPreviewer" },
	float = true,
})

hl.window_rule({
	name = "floating-file-picker",
	match = { class = "xdg-desktop-portal-gtk" },
	float = true,
})
