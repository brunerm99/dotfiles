local project_markers = {
  ".git",
  "pyproject.toml",
  "Cargo.toml",
  "package.json",
  "go.mod",
}

local media_programs = {
  -- Images
  avif = "feh",
  bmp = "feh",
  gif = "feh",
  heic = "feh",
  jpeg = "feh",
  jpg = "feh",
  png = "feh",
  svg = "feh",
  tif = "feh",
  tiff = "feh",
  webp = "feh",

  -- Videos
  avi = "mpv",
  flv = "mpv",
  m2ts = "mpv",
  m4v = "mpv",
  mkv = "mpv",
  mov = "mpv",
  mp4 = "mpv",
  mpeg = "mpv",
  mpg = "mpv",
  mts = "mpv",
  ogv = "mpv",
  ts = "mpv",
  webm = "mpv",
}

local is_macos = vim.uv.os_uname().sysname == "Darwin"

local function project_root()
  return vim.fs.root(0, project_markers) or vim.uv.cwd()
end

local function media_program(file)
  local extension = file:lower():match("%.([^./]+)$")
  local program = extension and media_programs[extension] or nil
  return program and (is_macos and "open" or program) or nil
end

local function open_media(file)
  local program = media_program(file)
  if not program then
    return false
  end

  local job = vim.fn.jobstart({ program, file }, { detach = true })
  if job <= 0 then
    vim.notify(("Could not open %s with %s"):format(file, program), vim.log.levels.ERROR)
  end

  return true
end

local function open_picker_file(selected, options)
  if #selected ~= 1 then
    require("fzf-lua.actions").file_edit_or_qf(selected, options)
    return
  end

  local path = require("fzf-lua.path")
  local entry = path.entry_to_file(selected[1], options)
  local file = entry.bufname or entry.path

  if not path.is_absolute(file) then
    file = vim.fs.joinpath(options.cwd or vim.uv.cwd(), file)
  end

  if open_media(file) then
    return
  end

  require("fzf-lua.actions").file_edit(selected, options)
end

vim.keymap.set("n", "<leader>f", function()
  require("fzf-lua").files({
    cwd = project_root(),
    actions = {
      ["enter"] = open_picker_file,
    },
    fzf_opts = {
      ["--scheme"] = "path",
      ["--tiebreak"] = "index",
    },
  })
end, { desc = "Find project files" })

vim.keymap.set("n", "<leader>g", function()
  require("fzf-lua").live_grep({ cwd = project_root() })
end, { desc = "Search project text" })

vim.keymap.set("n", "<leader>n", function()
  local top_level_only = false

  require("fzf-lua").lsp_document_symbols({
    symbol_style = 3,
    regex_filter = function(symbol)
      return symbol.kind ~= "Variable"
          and (not top_level_only or not symbol.text:match("^%s"))
    end,
    actions = {
      ["ctrl-o"] = {
        fn = function()
          top_level_only = not top_level_only
        end,
        reload = true,
        header = "toggle top level",
      },
    },
  })
end, { desc = "Outline current file" })

vim.keymap.set("n", "<leader>?", function()
  require("fzf-lua").keymaps({
    modes = { "n", "v", "i" },
    show_details = false,
  })
end, { desc = "Show keybindings" })

return {
  media_program = media_program,
  open_media = open_media,
  project_root = project_root,
}
