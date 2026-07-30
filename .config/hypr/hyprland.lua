--###############
--## VARIABLES ###
--###############

local mainMod = "SUPER"
local terminal = "ghostty"
local fileManager = "caja"
local menu = "rofi -show drun"
local browser = "zen-browser"
local musicplayer = "audacious"
local twitchplayer = "streamlink-twitch-gui"
local matrixclient = "element-desktop"
local passwordmanager = "keepassxc"

--############
--## HELPERS ##
--############

local function kb(key, action, opts)
  hl.bind(mainMod .. " + " .. key, action, opts)
end

local function exec(cmd)
  return hl.dsp.exec_cmd(cmd)
end

--###############
--## MONITORS ###
--###############

hl.monitor({
  output = "",
  mode = "1920x1080",
  position = "auto",
  scale = "1",
})

--##################
--## WORKSPACES ####
--##################

for i = 1, 5 do
  hl.workspace_rule({ workspace = tostring(i), persistent = true })
end

--########################
--## ENVIRONMENT VARS ####
--########################

-- Cursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "hyprcursor_Dracula")

-- Locale
hl.env("LANGUAGE", "de")
hl.env("LANG", "de_DE.UTF-8")

-- Qt
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- GTK
hl.env("GDK_DEBUG", "portals")
hl.env("GTK_USE_PORTAL", "1")

-- Desktop
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- NVIDIA (https://wiki.hyprland.org/Nvidia/)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- Other
hl.env("NVD_BACKEND", "direct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

--##############
--## CURVES ####
--##############

local function bezier(name, p1, p2)
  hl.curve(name, { type = "bezier", points = { p1, p2 } })
end

bezier("linear",        { 0, 0 },   { 1, 1 })
bezier("md3_standard",  { 0.2, 0 }, { 0, 1 })
bezier("md3_decel",     { 0.05, 0.7 }, { 0.1, 1 })
bezier("md3_accel",     { 0.3, 0 }, { 0.8, 0.15 })
bezier("overshot",      { 0.05, 0.9 }, { 0.1, 1.1 })
bezier("crazyshot",     { 0.1, 1.5 }, { 0.76, 0.92 })
bezier("hyprnostretch", { 0.05, 0.9 }, { 0.1, 1.0 })
bezier("menu_decel",    { 0.1, 1 }, { 0, 1 })
bezier("menu_accel",    { 0.38, 0.04 }, { 1, 0.07 })
bezier("easeInOutCirc", { 0.85, 0 }, { 0.15, 1 })
bezier("easeOutCirc",   { 0, 0.55 }, { 0.45, 1 })
bezier("easeOutExpo",   { 0.16, 1 }, { 0.3, 1 })
bezier("softAcDecel",   { 0.26, 0.26 }, { 0.15, 1 })
bezier("md2",           { 0.4, 0 }, { 0.2, 1 })

--#################
--## ANIMATIONS ####
--#################

local anim_configs = {
  { leaf = "windows",          speed = 3,    bezier = "md3_decel",  style = "popin 60%" },
  { leaf = "windowsIn",        speed = 3,    bezier = "md3_decel",  style = "popin 60%" },
  { leaf = "windowsOut",       speed = 3,    bezier = "md3_accel",  style = "popin 60%" },
  { leaf = "border",           speed = 10,   bezier = "default" },
  { leaf = "fade",             speed = 3,    bezier = "md3_decel" },
  { leaf = "layersIn",         speed = 3,    bezier = "menu_decel", style = "slide" },
  { leaf = "layersOut",        speed = 1.6,  bezier = "menu_accel" },
  { leaf = "fadeLayersIn",     speed = 2,    bezier = "menu_decel" },
  { leaf = "fadeLayersOut",    speed = 4.5,  bezier = "menu_accel" },
  { leaf = "workspaces",       speed = 7,    bezier = "menu_decel", style = "slide" },
  { leaf = "specialWorkspace", speed = 3,    bezier = "md3_decel",  style = "slidevert" },
}

for _, a in ipairs(anim_configs) do
  a.enabled = true
  hl.animation(a)
end

--##############
--## DEVICE ####
--##############

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

--###############
--## KEYBINDS ###
--###############

-- Launchers
kb("RETURN", exec(terminal))
kb("E", exec(fileManager))
kb("B", exec(browser))
kb("O", exec("tor-browser"))
kb("SPACE", exec(menu))
kb("ALT + M", exec(musicplayer))
kb("ALT + T", exec(twitchplayer))
kb("ALT + C", exec(matrixclient))
kb("ALT + K", exec(passwordmanager))
kb("ALT + S", exec("steam"))
kb("ALT + H", exec("heroic"))

-- Lock screen
kb("L", exec("hyprlock"))

-- Window operations
kb("Q", hl.dsp.window.close())
kb("SHIFT + Q", exec("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"))
kb("F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
kb("M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
kb("T", hl.dsp.window.float({ action = "toggle" }))
kb("J", hl.dsp.layout("togglesplit"))
kb("G", hl.dsp.group.toggle())
kb("K", hl.dsp.layout("swapsplit"))

-- Directional focus
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  kb(dir, hl.dsp.focus({ direction = dir }))
end

-- Mouse drag/resize
kb("mouse:272", hl.dsp.window.drag())
kb("mouse:273", hl.dsp.window.resize())

-- Resize window (SHIFT + direction)
for _, d in ipairs({
  { k = "right", x = 100,  y = 0 },
  { k = "left",  x = -100, y = 0 },
  { k = "down",  x = 0,    y = 100 },
  { k = "up",    x = 0,    y = -100 },
}) do
  kb("SHIFT + " .. d.k, hl.dsp.window.resize({ x = d.x, y = d.y, relative = true }))
end

-- Swap window (ALT + direction)
for _, d in ipairs({
  { k = "right", dir = "r" },
  { k = "left",  dir = "l" },
  { k = "up",    dir = "u" },
  { k = "down",  dir = "d" },
}) do
  kb("ALT + " .. d.k, hl.dsp.window.swap({ direction = d.dir }))
end

-- ALT + Tab cycle
hl.bind("ALT + Tab", hl.dsp.window.cycle_next({ next = true }), { repeating = true })
hl.bind("ALT + Tab", hl.dsp.window.bring_to_top(), { repeating = true })

-- Workspace switching
for i = 1, 10 do
  local key = i == 10 and "0" or tostring(i)
  kb(key, hl.dsp.focus({ workspace = i }))
  kb("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
  kb("CTRL + " .. key, exec("$HYPRSCRIPTS/moveTo.sh " .. i))
end

kb("Tab", hl.dsp.focus({ workspace = "m+1" }))
kb("SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))

-- Scroll/cycle workspaces
kb("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
kb("mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
kb("CTRL + down", hl.dsp.focus({ workspace = "empty" }))

-- Media keys
hl.bind("XF86AudioRaiseVolume",  exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),         { locked = true, repeating = true })
hl.bind("XF86AudioMute",         exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),        { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),      { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   exec("brightnessctl -e4 -n2 set 5%+"),                     { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", exec("brightnessctl -e4 -n2 set 5%-"),                     { locked = true, repeating = true })
hl.bind("XF86AudioNext",         exec("playerctl next"),                                    { locked = true })
hl.bind("XF86AudioPause",        exec("playerctl play-pause"),                              { locked = true })
hl.bind("XF86AudioPlay",         exec("playerctl play-pause"),                              { locked = true })
hl.bind("XF86AudioPrev",         exec("playerctl previous"),                                { locked = true })

-- Screenshots
hl.bind("Print",         exec('grim -g "$(slurp)" - | wl-copy && wl-paste > ~/Bilder/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of the region taken" -t 1000'))
hl.bind("SHIFT + Print", exec('grim - | wl-copy && wl-paste > ~/Bilder/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of whole screen taken" -t 1000'))

--####################
--## CONFIG (core) ###
--####################

hl.config({
  cursor = {
    no_hardware_cursors = true,
  },
  general = {
    gaps_in = 4,
    gaps_out = 4,
    border_size = 4,
    col = {
      active_border = { colors = { "rgba(b2c5ffff)", "rgba(E1BBDDFF)" }, angle = 45 },
      inactive_border = "rgba(E1BBDD11)",
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },
  decoration = {
    rounding = 12,
    active_opacity = 1.0,
    inactive_opacity = 0.9,
    blur = {
      enabled = true,
      size = 12,
      new_optimizations = true,
      ignore_opacity = true,
      xray = true,
    },
    shadow = {
      enabled = true,
      range = 30,
      render_power = 3,
      color = 0x66000000,
    },
  },
  animations = {
    enabled = true,
  },
  dwindle = {
    preserve_split = true,
    force_split = 2,
  },
  binds = {
    workspace_back_and_forth = true,
    allow_workspace_cycles = true,
    pass_mouse_when_bound = false,
  },
  input = {
    kb_layout = "de",
    numlock_by_default = true,
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = false,
    },
  },
})

--###############
--## AUTOSTART ##
--###############

hl.on("hyprland.start", function()
  local cmds = {
    "waybar",
    "hyprpaper",
    "systemctl --user start hyprpolkitagent",
    "hypridle",
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "wl-paste --watch cliphist store",
    "swaync",
    "nextcloud --background",
    "nm-applet --indicator",
  }
  for _, cmd in ipairs(cmds) do
    hl.exec_cmd(cmd)
  end
end)
