-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Stacked mode uses Hyprland's native monocle layout. Every tiled window
-- occupies the full usable workspace without being grouped, hidden, or
-- remapped, avoiding stale Wayland surfaces when returning to dwindle.
local function active_workspace()
  return hl.get_active_special_workspace() or hl.get_active_workspace()
end

local function workspace_selector(workspace)
  if workspace.special then
    return tostring(workspace.name)
  end
  return "name:" .. tostring(workspace.name)
end

o.pre_stack_layouts = o.pre_stack_layouts or {}

function o.toggle_workspace_stack()
  local workspace = active_workspace()
  if not workspace then
    return
  end

  local workspace_key = tostring(workspace.id) .. ":" .. tostring(workspace.name)
  local next_layout

  if workspace.tiled_layout == "monocle" then
    next_layout = o.pre_stack_layouts[workspace_key] or "dwindle"
    o.pre_stack_layouts[workspace_key] = nil
  else
    o.pre_stack_layouts[workspace_key] = workspace.tiled_layout
    next_layout = "monocle"
  end

  hl.workspace_rule({
    workspace = workspace_selector(workspace),
    layout = next_layout,
  })
end

-- Screenshot selection stays floating above monocle instead of becoming one
-- of its full-workspace windows.
hl.window_rule({
  name = "flameshot-stays-floating",
  match = { class = "(flameshot|org\\.flameshot\\.Flameshot)" },
  float = true,
  group = "barred",
})

-- SUPER+W used to close the focused window; move that behavior to SUPER+Q.
hl.unbind("SUPER + W")
hl.unbind("SUPER + Q")
o.bind("SUPER + Q", "Quit app", hl.dsp.window.close())
o.bind("SUPER + W", "Toggle tiled/stacked mode", o.toggle_workspace_stack)

-- In stacked mode these cycle the monocle layout; in tiled layouts they keep
-- their normal spatial-focus behavior.
function o.focus_stack_or_direction(direction)
  local workspace = active_workspace()
  if workspace and workspace.tiled_layout == "monocle" then
    hl.dispatch(hl.dsp.layout(direction == "u" and "cycleprev" or "cyclenext"))
  else
    hl.dispatch(hl.dsp.focus({ direction = direction }))
  end
end

hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")
o.bind("SUPER + UP", "Previous stacked window / focus up", function()
  o.focus_stack_or_direction("u")
end)
o.bind("SUPER + DOWN", "Next stacked window / focus down", function()
  o.focus_stack_or_direction("d")
end)

-- Vim-style directional window focus.
-- Replaces J: toggle split, K: keybindings menu, L: workspace layout.
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- Keybindings menu, alongside Vim-style focus navigation.
o.bind("SUPER + SHIFT + K", "Keybindings", "omarchy-menu-keybindings")

-- Open the top-bar calendar instead of a calendar web app.
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "Calendar", "omarchy-shell marchall.clock toggle")

-- Remove default social-media and messaging app launch shortcuts.
hl.unbind("SUPER + SHIFT + X") -- X
hl.unbind("SUPER + SHIFT + ALT + X") -- X Post
hl.unbind("SUPER + SHIFT + Y") -- YouTube
hl.unbind("SUPER + SHIFT + ALT + G") -- WhatsApp
hl.unbind("SUPER + SHIFT + G") -- Signal

-- Flameshot screenshot selection.
o.bind("SUPER + I", "Screenshot (Flameshot)", "env QT_QPA_PLATFORM=wayland flameshot gui")
o.bind("SUPER + U", "Power menu", "omarchy-menu toggle system")

-- Additional workspaces 11–22 on the function-key row.
for i = 1, 12 do
  local workspace = tostring(10 + i)
  o.bind("SUPER + F" .. i, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = workspace }))
  o.bind("SUPER + SHIFT + F" .. i, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = workspace }))
end
