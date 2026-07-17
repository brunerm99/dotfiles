local symbol_kind = vim.lsp.protocol.SymbolKind
local function_kinds = {
  [symbol_kind.Constructor] = true,
  [symbol_kind.Function] = true,
  [symbol_kind.Method] = true,
}

local function collect_functions(symbols, locations)
  for _, symbol in ipairs(symbols or {}) do
    if function_kinds[symbol.kind] then
      local range = symbol.selectionRange or symbol.range
      if symbol.location then
        range = symbol.location.range
      end

      if range then
        locations[range.start.line] = true
      end
    end

    collect_functions(symbol.children, locations)
  end
end

local function jump_to_function(direction)
  local buffer = vim.api.nvim_get_current_buf()
  local window = vim.api.nvim_get_current_win()
  local method = "textDocument/documentSymbol"
  local clients = vim.lsp.get_clients({ bufnr = buffer, method = method })

  if #clients == 0 then
    vim.notify("No language server provides document symbols here", vim.log.levels.WARN)
    return
  end

  local params = {
    textDocument = vim.lsp.util.make_text_document_params(buffer),
  }
  vim.lsp.buf_request_all(buffer, method, params, function(responses)
    if not vim.api.nvim_win_is_valid(window) or vim.api.nvim_win_get_buf(window) ~= buffer then
      return
    end

    local locations = {}
    for _, response in pairs(responses) do
      collect_functions(response.result, locations)
    end

    local lines = vim.tbl_keys(locations)
    table.sort(lines)

    if #lines == 0 then
      vim.notify("No functions found in this file", vim.log.levels.INFO)
      return
    end

    local current_line = vim.api.nvim_win_get_cursor(window)[1] - 1
    local target

    if direction > 0 then
      for _, line in ipairs(lines) do
        if line > current_line then
          target = line
          break
        end
      end
      target = target or lines[1]
    else
      for index = #lines, 1, -1 do
        if lines[index] < current_line then
          target = lines[index]
          break
        end
      end
      target = target or lines[#lines]
    end

    vim.api.nvim_win_set_cursor(window, { target + 1, 0 })
    vim.api.nvim_win_call(window, function()
      vim.cmd("normal! ^zz")
    end)
  end)
end

vim.keymap.set("n", "<M-Down>", function()
  jump_to_function(1)
end, { desc = "Next function" })

vim.keymap.set("n", "<M-Up>", function()
  jump_to_function(-1)
end, { desc = "Previous function" })

return {
  jump_to_function = jump_to_function,
}
