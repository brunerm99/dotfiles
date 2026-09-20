-- Reload unmodified buffers when another process (such as an AI agent)
-- changes their files on disk.
local reload_timer = vim.uv.new_timer()

reload_timer:start(500, 500, vim.schedule_wrap(function()
  if vim.fn.getcmdtype() == "" and vim.fn.getcmdwintype() == "" then
    vim.cmd("silent! checktime")
  end
end))

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    reload_timer:stop()
    reload_timer:close()
  end,
})
