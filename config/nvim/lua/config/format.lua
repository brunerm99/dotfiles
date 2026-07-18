local function formatter_for(buffer)
  local filetype = vim.bo[buffer].filetype

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buffer })) do
    local is_python_formatter = filetype ~= "python" or client.name == "ruff"
    if is_python_formatter and client:supports_method("textDocument/formatting", buffer) then
      return client
    end
  end
end

local function organize_python_imports(buffer)
  if vim.bo[buffer].filetype ~= "python" then
    return
  end

  local clients = vim.lsp.get_clients({
    bufnr = buffer,
    name = "ruff",
    method = "textDocument/codeAction",
  })
  local client = clients[1]
  if not client then
    return
  end

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(buffer),
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = vim.api.nvim_buf_line_count(buffer), character = 0 },
    },
    context = {
      diagnostics = {},
      only = { vim.lsp.protocol.CodeActionKind.SourceOrganizeImports },
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
    },
  }

  local response, request_error = client:request_sync(
    "textDocument/codeAction",
    params,
    2000,
    buffer
  )
  if not response then
    vim.notify("Ruff organize imports failed: " .. tostring(request_error), vim.log.levels.WARN)
    return
  end

  for _, action in ipairs(response.result or {}) do
    if not action.edit and client:supports_method("codeAction/resolve", buffer) then
      local resolved = client:request_sync("codeAction/resolve", action, 2000, buffer)
      action = resolved and resolved.result or action
    end

    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
      return
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
  callback = function(event)
    organize_python_imports(event.buf)

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
