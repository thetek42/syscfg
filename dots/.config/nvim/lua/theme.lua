local M = {}

function M.setup ()
    local everforest = require "everforest"
    everforest.setup {
        background = "hard",
        colours_override = function (p)
            p.bg0 = "#22272b"
            p.darker = "#272e33"
            p.grey_dark = "#5f6d6a"
        end,
        on_highlights = function (hl, p)
            hl["@attribute.zig"] = { link = "@keyword" }
            hl["@comment.documentation"] = { fg = p.grey1 }
            hl["@constructor.lua"] = { link = "@punctuation.delimiter" }
            hl["@function.builtin.zig"] = { link = "Orange" }
            hl["@keyword.import.zig"] = { link = "Orange" }
            hl["@keyword.modifier.zig"] = { link = "@keyword" }
            hl["@markup.heading.ini"] = { link = "Orange", bold = false }
            hl["@punctuation.bracket"] = { link = "@punctuation.delimiter" }
            hl["@punctuation.special.rust"] = { link = "@punctuation.delimiter" }
            hl["@string.documentation"] = { link = "@comment.documentation" }
            hl["@string.special.symbol"] = { link = "Blue" }
            hl["Comment"] = { fg = p.grey_dark }
            hl["CursorLineNr"] = { fg = p.green, bg = p.bg1 }
            hl["CursorLineSign"] = { bg = p.bg1 }
            hl["Directory"] = { fg = p.yellow, bold = true }
            hl["String"] = { link = "@string" }
            hl["StatusLine"] = { bg = p.bg1, fg = p.grey1 }
            hl["StatusLineFilename"] = { bg = p.bg1, fg = p.green }
            hl["StatusLineGrey"] = { bg = p.bg1, fg = p.grey1 }
            hl["StatusLineLocation"] = { bg = p.bg1, fg = p.aqua }
            hl["StatusLineModified"] = { bg = p.bg1, fg = p.yellow }
        end,
    }
    everforest.load ()
end

M.setup()

return M
