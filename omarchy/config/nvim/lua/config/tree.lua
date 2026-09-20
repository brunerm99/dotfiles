local api = require("nvim-tree.api")
local open_media = require("config.picker").open_media

local function window_config()
  local width = math.max(20, math.min(52, vim.o.columns - 4))
  local height = math.max(10, math.min(32, vim.o.lines - vim.o.cmdheight - 4))

  return {
    relative = "editor",
    border = "rounded",
    width = width,
    height = height,
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.max(0, math.floor((vim.o.columns - width) / 2)),
  }
end

local function on_attach(buffer)
  api.map.on_attach.default(buffer)

  local function options(description)
    return {
      buffer = buffer,
      desc = "File tree: " .. description,
      nowait = true,
      silent = true,
    }
  end

  local function open_node()
    local node = api.tree.get_node_under_cursor()
    if node and node.type == "file" and open_media(node.absolute_path) then
      api.tree.close()
      return
    end

    api.node.open.edit()
  end

  vim.keymap.set("n", "<CR>", open_node, options("open or expand"))
  vim.keymap.set("n", "o", open_node, options("open or expand"))
  vim.keymap.set("n", "l", open_node, options("open or expand"))
  vim.keymap.set("n", "<2-LeftMouse>", open_node, options("open or expand"))
  vim.keymap.set("n", "h", api.node.navigate.parent_close, options("collapse folder"))
end

require("nvim-tree").setup({
  on_attach = on_attach,
  disable_netrw = true,
  hijack_netrw = false,
  hijack_directories = {
    enable = false,
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
  },
  view = {
    number = true,
    relativenumber = true,
    float = {
      enable = true,
      quit_on_focus_loss = true,
      open_win_config = window_config,
    },
  },
  renderer = {
    highlight_git = "all",
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        folder = {
          arrow_closed = ">",
          arrow_open = "v",
        },
        git = {
          unstaged = "M",
          staged = "S",
          unmerged = "U",
          renamed = "R",
          untracked = "?",
          deleted = "D",
          ignored = "I",
        },
      },
    },
  },
  git = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("directory_landing_page", { clear = true }),
  once = true,
  callback = function()
    local argument = vim.fn.argv(0)
    if vim.fn.argc() ~= 1 or vim.fn.isdirectory(argument) ~= 1 then
      return
    end

    local directory = vim.fs.normalize(vim.fn.fnamemodify(argument, ":p"))
    vim.schedule(function()
      vim.api.nvim_set_current_dir(directory)
      api.tree.open({
        path = directory,
        focus = true,
      })
    end)
  end,
})

vim.keymap.set("n", "<leader>e", function()
  api.tree.toggle({
    find_file = true,
    focus = true,
  })
end, { desc = "Toggle file tree" })
