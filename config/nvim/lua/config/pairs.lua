require("nvim-autopairs").setup()

local function delete_square_surround()
  local buffer = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)

  vim.cmd.normal({ args = { "va[" }, bang = true })
  vim.cmd.normal({ args = { vim.keycode("<Esc>") }, bang = true })

  local first = vim.fn.getpos("'<")
  local last = vim.fn.getpos("'>")
  local first_row, first_col = first[2] - 1, first[3] - 1
  local last_row, last_col = last[2] - 1, last[3] - 1
  local opening = vim.api.nvim_buf_get_text(buffer, first_row, first_col, first_row, first_col + 1, {})
  local closing = vim.api.nvim_buf_get_text(buffer, last_row, last_col, last_row, last_col + 1, {})

  if opening[1] ~= "[" or closing[1] ~= "]" then
    vim.api.nvim_win_set_cursor(0, cursor)
    vim.notify("No surrounding square brackets")
    return
  end

  local contents = vim.api.nvim_buf_get_text(buffer, first_row, first_col, last_row, last_col + 1, {})
  contents[1] = contents[1]:sub(2)
  contents[#contents] = contents[#contents]:sub(1, -2)
  vim.api.nvim_buf_set_text(buffer, first_row, first_col, last_row, last_col + 1, contents)

  if cursor[1] == first_row + 1 and cursor[2] > first_col then
    cursor[2] = cursor[2] - 1
  end
  local line_length = #vim.api.nvim_buf_get_lines(buffer, cursor[1] - 1, cursor[1], false)[1]
  cursor[2] = math.min(cursor[2], line_length)
  vim.api.nvim_win_set_cursor(0, cursor)
end

vim.keymap.set("n", "ds[", delete_square_surround, {
  desc = "Delete surrounding square brackets",
})
