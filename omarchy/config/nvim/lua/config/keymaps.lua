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

vim.keymap.set("n", "<leader>/", function()
  local previous = vim.fn.bufnr("#")
  local has_previous_file = previous >= 0
    and vim.api.nvim_buf_is_valid(previous)
    and vim.bo[previous].buftype == ""
    and vim.api.nvim_buf_get_name(previous) ~= ""

  if not has_previous_file then
    vim.notify("No recent file")
    return
  end

  vim.cmd.buffer(previous)
end, { desc = "Open most recent file" })

-- Ctrl+/ may arrive as Ctrl+_ in terminals without extended keyboard support.
for _, key in ipairs({ "<C-/>", "<C-_>" }) do
  vim.keymap.set("n", key, "gcc", {
    remap = true,
    desc = "Toggle comment on current line",
  })
  vim.keymap.set("x", key, "gc", {
    remap = true,
    desc = "Toggle comment on selected lines",
  })
end

vim.api.nvim_create_user_command("Grip", function()
  local file = vim.api.nvim_buf_get_name(0)
  if vim.bo.filetype ~= "markdown" or file == "" then
    vim.notify("Grip requires a saved Markdown file", vim.log.levels.WARN)
    return
  end

  local go_grip = vim.fn.expand("~/go/bin/go-grip")
  if vim.fn.executable(go_grip) ~= 1 then
    vim.notify("go-grip is not executable: " .. go_grip, vim.log.levels.ERROR)
    return
  end

  local saved, save_error = pcall(vim.cmd.update)
  if not saved then
    vim.notify("Could not save Markdown file: " .. save_error, vim.log.levels.ERROR)
    return
  end

  local job = vim.fn.jobstart({ go_grip, file })
  if job <= 0 then
    vim.notify("Could not start go-grip", vim.log.levels.ERROR)
  end
end, { desc = "Preview current Markdown file with go-grip" })

return {
  scroll_amount = scroll_amount,
}
