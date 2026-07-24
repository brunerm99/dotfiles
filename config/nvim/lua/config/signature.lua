local method = "textDocument/signatureHelp"
local suppressed = {}

local function close_signature(buffer, suppress)
  buffer = buffer and buffer ~= 0 and buffer or vim.api.nvim_get_current_buf()

  if suppress then
    suppressed[buffer] = true
  end

  local window = vim.b[buffer].lsp_floating_preview
  if not window or not vim.api.nvim_win_is_valid(window) then
    return false
  end

  local ok, owner = pcall(vim.api.nvim_win_get_var, window, method)
  if not ok or owner ~= buffer then
    return false
  end

  vim.api.nvim_win_close(window, true)
  return true
end

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
    close_events = { "BufHidden", "BufLeave", "CursorMoved", "InsertLeave" },
    focus = false,
    focusable = false,
    max_height = 15,
    max_width = 90,
    silent = true,
  })
end

local signature_group = vim.api.nvim_create_augroup("automatic_signature_help", { clear = true })

vim.api.nvim_create_autocmd("InsertCharPre", {
  group = signature_group,
  callback = function(event)
    if not is_signature_trigger(event.buf, vim.v.char) then
      return
    end

    suppressed[event.buf] = nil

    vim.schedule(function()
      if vim.api.nvim_get_current_buf() == event.buf and vim.fn.mode():sub(1, 1) == "i" then
        show_signature()
      end
    end)
  end,
})

-- The LSP response is asynchronous and can arrive after InsertLeave. Wait one
-- event-loop tick for Neovim to tag the new float, then close stale responses.
vim.api.nvim_create_autocmd("WinNew", {
  group = signature_group,
  callback = function()
    vim.schedule(function()
      local buffer = vim.api.nvim_get_current_buf()
      if suppressed[buffer] or vim.fn.mode():sub(1, 1) ~= "i" then
        close_signature(buffer)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  group = signature_group,
  callback = function(event)
    suppressed[event.buf] = nil
  end,
})

return {
  close_signature = close_signature,
  is_signature_trigger = is_signature_trigger,
  show_signature = show_signature,
}
