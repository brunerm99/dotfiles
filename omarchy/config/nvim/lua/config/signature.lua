local method = "textDocument/signatureHelp"

local function is_signature_trigger(buffer, character)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buffer, method = method })) do
    local provider = client.server_capabilities.signatureHelpProvider or {}
    local triggers = vim.list_extend(
      vim.deepcopy(provider.triggerCharacters or {}),
      provider.retriggerCharacters or {}
    )

    if vim.tbl_contains(triggers, character) then
      return true
    end
  end

  return false
end

local function show_signature()
  vim.lsp.buf.signature_help({
    border = "rounded",
    close_events = { "BufHidden", "BufLeave", "InsertLeave" },
    focus = false,
    focusable = false,
    max_height = 15,
    max_width = 90,
    silent = true,
  })
end

vim.api.nvim_create_autocmd("InsertCharPre", {
  group = vim.api.nvim_create_augroup("automatic_signature_help", { clear = true }),
  callback = function(event)
    if not is_signature_trigger(event.buf, vim.v.char) then
      return
    end

    vim.schedule(function()
      if vim.api.nvim_get_current_buf() == event.buf and vim.fn.mode():sub(1, 1) == "i" then
        show_signature()
      end
    end)
  end,
})

return {
  is_signature_trigger = is_signature_trigger,
  show_signature = show_signature,
}
