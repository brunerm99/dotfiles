-- High-contrast syntax colors based on the colorblind-safe Okabe-Ito palette.
-- The Tokyo Night background and general UI colors remain unchanged.
local palette = {
  foreground = "#DDE4FF",
  comment = "#8290A8",
  blue = "#56B4E9",
  cyan = "#00D7FF",
  green = "#00D6A3",
  yellow = "#F0E442",
  orange = "#FFB000",
  vermillion = "#FF6B3D",
  magenta = "#E78AC3",
  punctuation = "#AAB6D3",
}

require("tokyonight").setup({
  style = "night",
  styles = {
    comments = { italic = true },
    functions = { bold = true },
    keywords = { bold = true },
  },
  on_highlights = function(highlights)
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

vim.cmd.colorscheme("tokyonight")
