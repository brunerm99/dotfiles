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

-- Treat the current workspace as either a normal tiling workspace or one
-- full-area tabbed group. Once every tiled app shares one group, that group is
-- the workspace's only layout container, so it fills the area below the bar
-- without involving Hyprland's fullscreen state.
local function clear_fullscreen(window)
  if window.fullscreen ~= 0 or window.fullscreen_client ~= 0 then
    hl.dispatch(hl.dsp.window.fullscreen_state({
      window = window,
      internal = 0,
      client = 0,
      layout_aware = false,
    }))
  end
end

local function ungroup_workspace(workspace)
  for _, group in ipairs(workspace:get_groups()) do
    local members = {}
    for _, window in ipairs(group.members or {}) do
      table.insert(members, window)
    end

    -- Use the dispatcher so each client receives a fresh tiled-size configure.
    -- Directly removing group members can leave Chromium surfaces at a stale
    -- size even though Hyprland has already resized their window borders.
    for index = #members, 2, -1 do
      if members[index].group == group then
        hl.dispatch(hl.dsp.window.move({ window = members[index], out_of_group = true }))
      end
    end

    if members[1] and members[1].group == group then
      hl.dispatch(hl.dsp.group.toggle({ window = members[1] }))
    end
  end
end

local stack_excluded_classes = {
  ["flameshot"] = true,
  ["org.flameshot.flameshot"] = true,
}

local function window_is_stackable(window)
  local class = string.lower(window.class or "")
  return window.mapped and not window.floating and not window.pinned
    and not stack_excluded_classes[class]
end

local function stackable_workspace_windows(workspace)
  local windows = {}
  for _, window in ipairs(hl.get_workspace_windows(workspace)) do
    if window_is_stackable(window) then
      table.insert(windows, window)
    end
  end
  return windows
end

local function workspace_is_stacked(windows)
  if #windows == 0 then
    return false
  end

  local group = windows[1].group
  if not group then
    return false
  end

  for _, window in ipairs(windows) do
    if window.group ~= group then
      return false
    end
  end

  return true
end

-- Screenshot and transient floating windows must remain above, rather than
-- being swallowed into the active tabbed group.
hl.window_rule({
  name = "flameshot-stays-out-of-groups",
  match = { class = "(flameshot|org\\.flameshot\\.Flameshot)" },
  group = "barred",
})
hl.window_rule({
  name = "floating-windows-stay-out-of-groups",
  match = { float = true },
  group = "barred",
})

function o.toggle_workspace_stack()
  local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
  if not workspace then
    return
  end

  local windows = stackable_workspace_windows(workspace)

  if #windows == 0 then
    hl.notification.create({ text = "No windows to stack", timeout = 1500, icon = "info" })
    return
  end

  local focused = hl.get_active_window()

  if workspace_is_stacked(windows) then
    for _, window in ipairs(windows) do
      clear_fullscreen(window)
    end
    ungroup_workspace(workspace)

    if focused and focused.workspace == workspace then
      hl.dispatch(hl.dsp.focus({ window = focused }))
    end
    return
  end

  -- Stacked mode deliberately normalizes every tiled app to non-fullscreen
  -- state before placing it in the shared tabbed container.
  for _, window in ipairs(windows) do
    clear_fullscreen(window)
  end
  ungroup_workspace(workspace)

  local anchor = focused
  if not anchor or anchor.workspace ~= workspace or not window_is_stackable(anchor) then
    anchor = windows[1]
  end

  hl.dispatch(hl.dsp.group.toggle({ window = anchor }))
  local stack = anchor.group
  if not stack then
    hl.notification.create({ text = "Could not create stacked mode", timeout = 2500, icon = "error" })
    return
  end

  for _, window in ipairs(windows) do
    if window ~= anchor then
      stack:add(window)
    end
  end

  hl.dispatch(hl.dsp.focus({ window = anchor }))
end

-- SUPER+W used to close the focused window; move that behavior to SUPER+Q.
hl.unbind("SUPER + W")
hl.unbind("SUPER + Q")
o.bind("SUPER + Q", "Quit app", hl.dsp.window.close())
o.bind("SUPER + W", "Toggle tiled/stacked mode", o.toggle_workspace_stack)

-- Keep spatial navigation in tiled mode, but use the same keys as previous
-- and next while the focused window belongs to a stack.
function o.focus_stack_or_direction(direction)
  local window = hl.get_active_window()
  if window and window.group then
    if direction == "u" then
      hl.dispatch(hl.dsp.group.prev({ window = window }))
    else
      hl.dispatch(hl.dsp.group.next({ window = window }))
    end
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
