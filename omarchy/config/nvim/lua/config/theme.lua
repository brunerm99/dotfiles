local current_state = vim.fn.expand("~/.local/state/omarchy/current")
local theme_dir = current_state .. "/theme"
local theme_runtime = theme_dir .. "/nvim"

vim.opt.termguicolors = true
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block,a:blinkon0-Cursor"
vim.opt.runtimepath:prepend(theme_runtime)

local function apply_workbench()
  local colorscheme = theme_runtime .. "/colors/workbench.lua"
  if vim.fn.filereadable(colorscheme) ~= 1 then
    vim.notify("The active Omarchy theme does not provide the Workbench Neovim palette", vim.log.levels.WARN)
    return
  end

  vim.o.background = vim.fn.filereadable(theme_dir .. "/light.mode") == 1 and "light" or "dark"

  local ok, error_message = pcall(vim.cmd.colorscheme, "workbench")
  if not ok then
    vim.notify("Could not apply the Workbench theme: " .. error_message, vim.log.levels.ERROR)
  end
end

apply_workbench()

-- Omarchy swaps the entire current theme directory atomically. Watch its
-- parent so a running Neovim follows Workbench Light/Dark switches as well.
local watcher = vim.uv.new_fs_event()
local debounce = vim.uv.new_timer()

if watcher and debounce then
  watcher:start(current_state, {}, function(error_message, filename)
    if error_message then
      return
    end
    if filename and filename ~= "theme" and filename ~= "theme.name" then
      return
    end

    debounce:stop()
    debounce:start(150, 0, vim.schedule_wrap(apply_workbench))
  end)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("workbench_theme_watcher", { clear = true }),
    callback = function()
      if not watcher:is_closing() then
        watcher:stop()
        watcher:close()
      end
      if not debounce:is_closing() then
        debounce:stop()
        debounce:close()
      end
    end,
  })
end
