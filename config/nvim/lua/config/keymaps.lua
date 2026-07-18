local repeat_window_ms = 180
local scroll_states = {
  down = { last_time = 0, repeats = 0 },
  up = { last_time = 0, repeats = 0 },
}

local function scroll_amount(repeats)
  if repeats <= 3 then
    return 1
  elseif repeats <= 7 then
    return 2
  elseif repeats <= 12 then
    return 4
  end

  return 8
end

local function accelerated_scroll(direction, key)
  local state = scroll_states[direction]
  local other_direction = direction == "down" and "up" or "down"
  local now = vim.uv.hrtime() / 1000000

  if now - state.last_time <= repeat_window_ms then
    state.repeats = state.repeats + 1
  else
    state.repeats = 1
  end

  state.last_time = now
  scroll_states[other_direction] = { last_time = 0, repeats = 0 }

  vim.cmd.normal({
    args = { tostring(scroll_amount(state.repeats)) .. vim.keycode(key) },
    bang = true,
  })
end

vim.keymap.set("n", "<C-e>", function()
  accelerated_scroll("down", "<C-e>")
end, {
  silent = true,
  desc = "Scroll down with acceleration",
})

vim.keymap.set("n", "<C-y>", function()
  accelerated_scroll("up", "<C-y>")
end, {
  silent = true,
  desc = "Scroll up with acceleration",
})

return {
  scroll_amount = scroll_amount,
}
