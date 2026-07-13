-- Hyprland Lua config migrated from hyprland.conf.
-- See https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@100.00Hz",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@60.00Hz",
    position = "-1920x0",
    scale    = 1,
})

hl.monitor({
    output   = "HDMI-A-2",
    mode     = "1366x768@60.00Hz",
    position = "-1366x0",
    scale    = 1,
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "nemo"
local menu        = "wofi --show drun"
local sym         = "/home/marchall/documents/sym/symbol-picker.sh"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper & hyprsunset")
    hl.exec_cmd("/home/marchall/.config/waybar/scripts/workspace-watch.py")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 }    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 }    } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 }       } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1.0 }  } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 }     } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint",   style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",         style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint",   style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",         style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear",   style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear",   style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear",   style = "fade" })

hl.config({
    dwindle = {
        preserve_split = true,
    },

    group = {
        groupbar = {
            enabled = false,
        },
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = false,
        disable_splash_rendering = true,
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,ru",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_space_toggle",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("flameshot gui"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(sym))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + Z", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + T", hl.dsp.group.toggle())
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("/home/marchall/.config/hypr/scripts/toggle-workspace-layout"))
hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("/home/marchall/documents/small-scripts/power"))
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("pavucontrol -t 3"))

-- Move focus with mainMod + vim keys.
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + up", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + t", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mainMod .. " + down", hl.dsp.group.prev())
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))

hl.bind(mainMod .. " + SHIFT + n", hl.dsp.workspace.move({ monitor = "-1" }))
hl.bind(mainMod .. " + SHIFT + m", hl.dsp.workspace.move({ monitor = "+1" }))

local workspaceKeys = {
    { "1", 1 },
    { "2", 2 },
    { "3", 3 },
    { "4", 4 },
    { "5", 5 },
    { "6", 6 },
    { "7", 7 },
    { "8", 8 },
    { "9", 9 },
    { "0", 10 },
    { "F1", 11 },
    { "F2", 12 },
    { "F3", 13 },
    { "F4", 14 },
    { "F5", 15 },
    { "F6", 16 },
    { "F7", 17 },
    { "F8", 18 },
    { "F9", 19 },
    { "F10", 20 },
}

for _, workspaceKey in ipairs(workspaceKeys) do
    local key, workspace = workspaceKey[1], workspaceKey[2]
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Converted from ~/.config/hypremoji/hypremoji.conf.
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("hypremoji"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "pavucontrol-float",
    match = { class = "^(org.pulseaudio.pavucontrol)$" },
    float = true,
    size  = { 1200, 600 },
})

hl.window_rule({
    name  = "blueberry-float",
    match = { class = "^(blueberry.py)$" },
    float = true,
    size  = { 700, 800 },
})

hl.window_rule({
    name  = "calc-float",
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
    size  = { 700, 800 },
})

hl.window_rule({
    name  = "mpv-float",
    match = { class = "^(mpv)$" },
    float = true,
    size  = { 700, 800 },
})

hl.window_rule({
    name  = "matplotlib-float",
    match = { class = "^(Matplotlib)$" },
    float = true,
    size  = { 1200, 800 },
})

hl.window_rule({
    name  = "feh-float",
    match = { class = "^(feh)$" },
    float = true,
    size  = { 1200, 800 },
})

hl.window_rule({
    name  = "flameshot-isolate-from-groups",
    match = { class = "^(flameshot)$" },
    float = true,
    group = "deny",
})

hl.window_rule({
    name  = "flameshot-pin-float",
    match = {
        class = "^(flameshot)$",
        title = "^(flameshot-pin)$",
    },
    float = true,
    size  = { 1200, 800 },
})

hl.window_rule({
    name  = "hypremoji-float",
    match = { title = "^(HyprEmoji)$" },
    float = true,
})

hl.window_rule({
    name  = "hypremoji-position",
    match = { title = "^(HyprEmoji)$" },
    move  = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.05)" },
})

hl.window_rule({
    name  = "hypremoji-size",
    match = { title = "^(HyprEmoji)$" },
    size  = { 307, 340 },
})

hl.window_rule({
    name  = "nmtui-float",
    match = {
        class = "^(org.marchall.nmtui)$",
        title = "^(nmtui)$",
    },
    float = true,
    size  = { 900, 650 },
})

hl.window_rule({
    name  = "systui-float",
    match = {
        class = "^(org.marchall.systui)$",
        title = "^(systui)$",
    },
    float = true,
    size  = { "1600", "900" },
	center = true,
})

hl.window_rule({
    name  = "steam-friends-float",
    match = {
        class = "^(steam)$",
        title = "^(Friends List)$",
    },
    float = true,
    size  = { 430, 760 },
})

hl.window_rule({
    name  = "steam-messages-float",
    match = {
        class = "^(steam)$",
        title = ".*(Chat|Message|Messages).*",
    },
    float = true,
    size  = { 720, 620 },
})

-- Ignore maximize requests from apps.
-- hl.window_rule({
--     name = "suppress-maximize-events",
--     match = { class = ".*" },
--     suppress_event = "maximize",
-- })

-- Fix some dragging issues with XWayland.
-- hl.window_rule({
--     name = "fix-xwayland-drags",
--     match = {
--         class = "^$",
--         title = "^$",
--         xwayland = true,
--         float = true,
--         fullscreen = false,
--         pin = false,
--     },
--     no_focus = true,
-- })

hl.layer_rule({
    name = "waybar-blur",
    match = { namespace = "^waybar$" },
    blur = true,
    ignore_alpha = 0.5,
})
