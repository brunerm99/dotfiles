local function formatter_for(buffer)
  local filetype = vim.bo[buffer].filetype

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buffer })) do
    local is_python_formatter = filetype ~= "python" or client.name == "ruff"
    if is_python_formatter and client:supports_method("textDocument/formatting", buffer) then
      return client
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    local formatter = formatter_for(event.buf)
    if not formatter then
      return
    end

    vim.lsp.buf.format({
      bufnr = event.buf,
      id = formatter.id,
      timeout_ms = 2000,
    })
  end,
})
