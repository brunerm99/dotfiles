-- High-contrast syntax colors based on the colorblind-safe Okabe-Ito palette.
-- These overrides apply in dark mode; light mode uses Tokyo Night Day.
local palette = {
  foreground = "#DDE4FF",
  comment = "#8290A8",
  blue = "#6DAFD1",
  cyan = "#56BDC8",
  green = "#57B99B",
  yellow = "#D5C95E",
  orange = "#C99B62",
  vermillion = "#D37B67",
  magenta = "#C68DB5",
  punctuation = "#98A5C2",
}

require("tokyonight").setup({
  style = "night",
  light_style = "day",
  styles = {
    comments = { italic = true },
    functions = { bold = true },
    keywords = { bold = true },
  },
  on_highlights = function(highlights)
    if vim.o.background == "light" then
      return
    end

    highlights.Normal = { fg = palette.foreground, bg = "#1A1B26" }
    highlights.CursorLine = { bg = "#243352" }
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
    highlights["@variable.builtin"] = { fg = palette.vermillion, bold = true }
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
