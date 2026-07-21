-- Keep the Kraken dark palette and use the matching terminal palette in light mode.
local dark_palette = {
  background = "#1A1B26",
  foreground = "#DDE4FF",
  cursor_line = "#243352",
  comment = "#8290A8",
  blue = "#6DAFD1",
  cyan = "#56BDC8",
  green = "#57B99B",
  yellow = "#D5C95E",
  orange = "#C99B62",
  vermillion = "#D37B67",
  builtin = "#D37B67",
  magenta = "#C68DB5",
  punctuation = "#98A5C2",
  terminal = {
    black = "#15161E",
    red = "#F7768E",
    green = "#9ECE6A",
    yellow = "#E0AF68",
    blue = "#7AA2F7",
    magenta = "#BB9AF7",
    cyan = "#7DCFFF",
    white = "#A9B1D6",
    bright_black = "#414868",
    bright_red = "#F7768E",
    bright_green = "#9ECE6A",
    bright_yellow = "#E0AF68",
    bright_blue = "#7AA2F7",
    bright_magenta = "#BB9AF7",
    bright_cyan = "#7DCFFF",
    bright_white = "#C0CAF5",
  },
}

local light_palette = {
  background = "#FBF7F0",
  foreground = "#000000",
  cursor = "#D00000",
  cursor_text = "#FBF7F0",
  cursor_line = "#C2BCB5",
  selection_background = "#C2BCB5",
  selection_foreground = "#000000",
  comment = "#595959",
  blue = "#0031A9",
  cyan = "#005E8B",
  green = "#006800",
  yellow = "#6F5500",
  orange = "#884900",
  vermillion = "#972500",
  builtin = "#A60000",
  magenta = "#721045",
  punctuation = "#595959",
  terminal = {
    black = "#000000",
    red = "#A60000",
    green = "#006800",
    yellow = "#6F5500",
    blue = "#0031A9",
    magenta = "#721045",
    cyan = "#005E8B",
    white = "#A6A6A6",
    bright_black = "#595959",
    bright_red = "#972500",
    bright_green = "#00663F",
    bright_yellow = "#884900",
    bright_blue = "#3548CF",
    bright_magenta = "#531AB6",
    bright_cyan = "#005F5F",
    bright_white = "#595959",
  },
}

local function set_terminal_colors(colors, terminal)
  colors.terminal = {
    black = terminal.black,
    black_bright = terminal.bright_black,
    red = terminal.red,
    red_bright = terminal.bright_red,
    green = terminal.green,
    green_bright = terminal.bright_green,
    yellow = terminal.yellow,
    yellow_bright = terminal.bright_yellow,
    blue = terminal.blue,
    blue_bright = terminal.bright_blue,
    magenta = terminal.magenta,
    magenta_bright = terminal.bright_magenta,
    cyan = terminal.cyan,
    cyan_bright = terminal.bright_cyan,
    white = terminal.white,
    white_bright = terminal.bright_white,
  }
end

local function set_light_colors(colors)
  local terminal = light_palette.terminal

  colors.bg = light_palette.background
  colors.bg_dark = light_palette.background
  colors.bg_dark1 = light_palette.background
  colors.bg_highlight = light_palette.selection_background
  colors.bg_popup = light_palette.background
  colors.bg_statusline = light_palette.selection_background
  colors.bg_sidebar = light_palette.background
  colors.bg_float = light_palette.background
  colors.bg_visual = light_palette.selection_background
  colors.bg_search = light_palette.selection_background
  colors.fg = light_palette.foreground
  colors.fg_dark = terminal.bright_black
  colors.fg_gutter = terminal.bright_black
  colors.fg_sidebar = terminal.bright_black
  colors.fg_float = light_palette.foreground
  colors.black = terminal.black
  colors.comment = light_palette.comment
  colors.dark3 = terminal.bright_black
  colors.dark5 = terminal.bright_black
  colors.blue = terminal.blue
  colors.blue0 = terminal.bright_blue
  colors.blue1 = terminal.cyan
  colors.blue2 = terminal.cyan
  colors.blue5 = terminal.bright_cyan
  colors.blue6 = terminal.bright_cyan
  colors.blue7 = terminal.bright_blue
  colors.cyan = terminal.cyan
  colors.green = terminal.green
  colors.green1 = terminal.bright_green
  colors.green2 = terminal.bright_green
  colors.yellow = terminal.yellow
  colors.orange = terminal.bright_yellow
  colors.magenta = terminal.magenta
  colors.magenta2 = terminal.bright_magenta
  colors.purple = terminal.bright_magenta
  colors.red = terminal.red
  colors.red1 = terminal.bright_red
  colors.teal = terminal.bright_cyan
  colors.terminal_black = terminal.bright_black
  colors.border = terminal.bright_black
  colors.border_highlight = terminal.bright_black
  colors.error = terminal.red
  colors.warning = terminal.yellow
  colors.info = terminal.blue
  colors.hint = terminal.cyan
  colors.todo = terminal.magenta
  colors.git = {
    add = terminal.green,
    change = terminal.blue,
    delete = terminal.red,
    ignore = terminal.bright_black,
  }
  colors.diff = {
    add = light_palette.background,
    change = light_palette.background,
    delete = light_palette.background,
    text = light_palette.selection_background,
  }
  colors.rainbow = {
    terminal.blue,
    terminal.yellow,
    terminal.green,
    terminal.cyan,
    terminal.magenta,
    terminal.bright_magenta,
    terminal.bright_yellow,
    terminal.red,
  }
end

local function set_syntax_highlights(highlights, palette)
  highlights.Normal = { fg = palette.foreground, bg = palette.background }
  highlights.CursorLine = { bg = palette.cursor_line }
  highlights.Comment = { fg = palette.comment, italic = true }
  highlights.Identifier = { fg = palette.foreground }
  highlights.Function = { fg = palette.blue, bold = true }
  highlights.Keyword = { fg = palette.magenta, bold = true }
  highlights.Statement = { fg = palette.magenta, bold = true }
  highlights.Type = { fg = palette.green, bold = true }
  highlights.String = { fg = palette.yellow }
  highlights.Number = { fg = palette.vermillion, bold = true }
  highlights.Float = "Number"
  highlights.Constant = { fg = palette.orange, bold = true }
  highlights.Operator = { fg = palette.cyan, bold = true }
  highlights.Delimiter = { fg = palette.punctuation }
  highlights.PreProc = { fg = palette.magenta, bold = true }
  highlights.Special = { fg = palette.vermillion }

  highlights["@variable"] = "Identifier"
  highlights["@variable.builtin"] = { fg = palette.builtin, bold = true }
  highlights["@variable.member"] = { fg = palette.orange }
  highlights["@variable.parameter"] = { fg = palette.orange }
  highlights["@function"] = "Function"
  highlights["@function.builtin"] = { fg = palette.blue, bold = true, italic = true }
  highlights["@function.method"] = "Function"
  highlights["@keyword"] = "Keyword"
  highlights["@keyword.function"] = "Keyword"
  highlights["@type"] = "Type"
  highlights["@type.builtin"] = { fg = palette.green, bold = true }
  highlights["@constructor"] = { fg = palette.green, bold = true }
  highlights["@string"] = "String"
  highlights["@number"] = "Number"
  highlights["@constant"] = "Constant"
  highlights["@property"] = { fg = palette.orange }
  highlights["@operator"] = "Operator"
  highlights["@punctuation.bracket"] = { fg = palette.punctuation }
  highlights["@punctuation.delimiter"] = { fg = palette.punctuation }
end

local function set_light_ui_highlights(highlights)
  local palette = light_palette
  local terminal = palette.terminal

  highlights.NormalNC = "Normal"
  highlights.NormalFloat = "Normal"
  highlights.FloatBorder = { fg = terminal.bright_black, bg = palette.background }
  highlights.SignColumn = { bg = palette.background }
  highlights.FoldColumn = { fg = terminal.bright_black, bg = palette.background }
  highlights.EndOfBuffer = { fg = palette.background, bg = palette.background }
  highlights.Cursor = { fg = palette.cursor_text, bg = palette.cursor }
  highlights.lCursor = "Cursor"
  highlights.CursorIM = "Cursor"
  highlights.TermCursor = "Cursor"
  highlights.CursorColumn = { bg = palette.cursor_line }
  highlights.Visual = {
    fg = palette.selection_foreground,
    bg = palette.selection_background,
  }
  highlights.VisualNOS = "Visual"
  highlights.Search = {
    fg = palette.selection_foreground,
    bg = palette.selection_background,
  }
  highlights.IncSearch = { fg = palette.cursor_text, bg = palette.cursor }
  highlights.CurSearch = "IncSearch"
  highlights.LineNr = { fg = terminal.bright_black, bg = palette.background }
  highlights.CursorLineNr = { fg = palette.foreground, bg = palette.cursor_line, bold = true }
  highlights.Pmenu = { fg = palette.foreground, bg = palette.background }
  highlights.PmenuSel = {
    fg = palette.selection_foreground,
    bg = palette.selection_background,
  }
  highlights.StatusLine = { fg = palette.foreground, bg = palette.selection_background }
  highlights.StatusLineNC = { fg = terminal.bright_black, bg = palette.selection_background }
  highlights.WinSeparator = { fg = terminal.bright_black, bg = palette.background }
  highlights.DiffAdd = { fg = terminal.green, bg = palette.background }
  highlights.DiffChange = { fg = terminal.blue, bg = palette.background }
  highlights.DiffDelete = { fg = terminal.red, bg = palette.background }
  highlights.DiffText = { fg = palette.cursor_text, bg = terminal.blue, bold = true }
end

require("tokyonight").setup({
  style = "night",
  light_style = "day",
  styles = {
    comments = { italic = true },
    functions = { bold = true },
    keywords = { bold = true },
  },
  on_colors = function(colors)
    local palette = vim.o.background == "light" and light_palette or dark_palette

    set_terminal_colors(colors, palette.terminal)
    if vim.o.background == "light" then
      set_light_colors(colors)
    end
  end,
  on_highlights = function(highlights)
    local palette = vim.o.background == "light" and light_palette or dark_palette

    set_syntax_highlights(highlights, palette)
    if vim.o.background == "light" then
      set_light_ui_highlights(highlights)
    end
  end,
})

local function apply_colorscheme()
  local colorscheme = vim.o.background == "light" and "tokyonight-day" or "tokyonight-night"

  if vim.g.colors_name ~= colorscheme then
    vim.cmd.colorscheme(colorscheme)
  end
end

local background_group = vim.api.nvim_create_augroup("tokyonight_background", { clear = true })

vim.api.nvim_create_autocmd("OptionSet", {
  group = background_group,
  pattern = "background",
  callback = function()
    -- Wait until Neovim finishes its automatic colorscheme reload, then select
    -- the configured Tokyo Night variant instead of the plugin's Moon fallback.
    vim.schedule(apply_colorscheme)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = background_group,
  pattern = "tokyonight*",
  callback = function()
    vim.schedule(apply_colorscheme)
  end,
})

apply_colorscheme()
