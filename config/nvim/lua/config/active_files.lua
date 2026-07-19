local M = {}

local max_files = 9
local state_file = vim.fn.stdpath("state") .. "/active-files.json"
local state

local function load_state()
  if state then
    return state
  end

  local ok, lines = pcall(vim.fn.readfile, state_file)
  if not ok then
    state = {}
    return state
  end

  local decoded_ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
  state = decoded_ok and type(decoded) == "table" and decoded or {}
  return state
end

local function save_state()
  vim.fn.mkdir(vim.fs.dirname(state_file), "p")
  vim.fn.writefile({ vim.json.encode(load_state()) }, state_file)
end

local function project_root()
  return vim.fs.normalize(require("config.picker").project_root())
end

local function project_files(root)
  local projects = load_state()
  projects[root] = projects[root] or {}
  return projects[root]
end

local function current_file()
  if vim.bo.buftype ~= "" then
    return nil
  end

  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil
  end

  return vim.fs.normalize(vim.fn.fnamemodify(file, ":p"))
end

local function display_path(file, root)
  local relative = vim.fs.relpath(root, file)
  return relative or file
end

local function open_file(file)
  if vim.fn.filereadable(file) == 0 then
    vim.notify("Active file no longer exists: " .. file, vim.log.levels.WARN)
    return false
  end

  if require("config.picker").open_media(file) then
    return true
  end

  vim.cmd.edit(vim.fn.fnameescape(file))
  return true
end

local function remove_slot(root, slot)
  local files = project_files(root)
  local file = table.remove(files, slot)
  if not file then
    return false
  end

  save_state()
  return true, file
end

local function selected_slot(selected)
  return selected[1] and tonumber(selected[1]:match("^(%d+)%s%s")) or nil
end

function M.add()
  local file = current_file()
  if not file then
    vim.notify("The current buffer is not a file", vim.log.levels.WARN)
    return
  end

  local root = project_root()
  local files = project_files(root)
  for slot, active_file in ipairs(files) do
    if active_file == file then
      vim.notify(("Already active in slot %d: %s"):format(slot, display_path(file, root)))
      return
    end
  end

  if #files >= max_files then
    vim.notify("Active file list is full; remove a file first", vim.log.levels.WARN)
    return
  end

  table.insert(files, file)
  save_state()
  vim.notify(("Added active file %d: %s"):format(#files, display_path(file, root)))
end

function M.remove_current()
  local file = current_file()
  if not file then
    vim.notify("The current buffer is not a file", vim.log.levels.WARN)
    return
  end

  local root = project_root()
  local files = project_files(root)
  for slot, active_file in ipairs(files) do
    if active_file == file then
      remove_slot(root, slot)
      vim.notify(("Removed active file: %s"):format(display_path(file, root)))
      return
    end
  end

  vim.notify("The current file is not in the active list")
end

function M.open(slot)
  local root = project_root()
  local files = project_files(root)
  local file = files[slot]
  if not file then
    vim.notify(("No active file in slot %d"):format(slot), vim.log.levels.WARN)
    return
  end

  if not open_file(file) then
    remove_slot(root, slot)
  end
end

function M.list()
  local root = project_root()

  local function contents(callback)
    for slot, file in ipairs(project_files(root)) do
      callback(("%d  %s"):format(slot, display_path(file, root)))
    end
    callback()
  end

  require("fzf-lua").fzf_exec(contents, {
    prompt = "Active files> ",
    previewer = false,
    actions = {
      ["enter"] = function(selected)
        local slot = selected_slot(selected)
        if slot then
          open_file(project_files(root)[slot])
        end
      end,
      ["ctrl-x"] = {
        fn = function(selected)
          local slot = selected_slot(selected)
          if slot then
            remove_slot(root, slot)
          end
        end,
        reload = true,
        header = "remove",
      },
    },
    fzf_opts = {
      ["--no-multi"] = true,
      ["--tiebreak"] = "index",
    },
  })
end

function M.setup()
  vim.keymap.set("n", "<leader>a", M.add, { desc = "Add active file" })
  vim.keymap.set("n", "<leader>w", M.list, { desc = "Show active files" })
  vim.keymap.set("n", "<leader>x", M.remove_current, { desc = "Remove active file" })

  for slot = 1, max_files do
    vim.keymap.set("n", "<leader>" .. slot, function()
      M.open(slot)
    end, { desc = ("Open active file %d"):format(slot) })
  end
end

return M
