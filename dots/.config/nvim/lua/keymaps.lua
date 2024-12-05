local opts = { noremap = true, silent = true }
local opts_buf = { noremap = true, silent = true, buffer = true }
local opts_expr = { noremap = true, silent = true, expr = true }

-- leader

vim.g.mapleader = " "

-- movement

vim.keymap.set ("n", "j", [[ v:count == 0 ? 'gj' : 'j' ]], opts_expr)
vim.keymap.set ("n", "k", [[ v:count == 0 ? 'gk' : 'k' ]], opts_expr)

-- window management

vim.keymap.set ("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set ("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set ("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set ("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set ("n", "<C-S-h>", "<C-w>H", opts)
vim.keymap.set ("n", "<C-S-j>", "<C-w>J", opts)
vim.keymap.set ("n", "<C-S-k>", "<C-w>K", opts)
vim.keymap.set ("n", "<C-S-l>", "<C-w>L", opts)
vim.keymap.set ("n", "<C-Up>", "<CMD>resize +2<CR>", opts)
vim.keymap.set ("n", "<C-Down>", "<CMD>resize -2<CR>", opts)
vim.keymap.set ("n", "<C-Left>", "<CMD>vertical resize -2<CR>", opts)
vim.keymap.set ("n", "<C-Right>", "<CMD>vertical resize +2<CR>", opts)

-- buffer management

vim.keymap.set ("n", "<leader>bd", "<CMD>bprevious | bdelete #<CR>", opts)
vim.keymap.set ("n", "<leader>bD", "<CMD>bprevious | bdelete! #<CR>", opts)
vim.keymap.set ("n", "<leader>bk", "<CMD>write | %bdelete | edit # | bdelete #<CR>|'\"", opts) -- delete all buffers except current

-- options

local function opt_toggle (option)
    return function ()
        vim.opt_local[option] = not vim.opt_local[option]
    end
end

vim.keymap.set ("n", "<leader>os", opt_toggle "spell", opts)
vim.keymap.set ("n", "<leader>ow", opt_toggle "wrap", opts)
vim.keymap.set ("n", "<leader>oW", opt_toggle "linebreak", opts)

-- buffer management

vim.keymap.set ("n", "<S-h>", "<CMD>bprevious<CR>", opts)
vim.keymap.set ("n", "<S-l>", "<CMD>bnext<CR>", opts)
vim.keymap.set ("n", "<M-h>", "<CMD>bfirst<CR>", opts)
vim.keymap.set ("n", "<M-l>", "<CMD>blast<CR>", opts)

-- popup menu and completion

vim.keymap.set ("i", "<C-j>", [[ pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>" ]], opts_expr)
vim.keymap.set ("i", "<C-k>", [[ pumvisible() ? "\<C-p>" : "\<C-k>" ]], opts_expr)

-- oil

vim.keymap.set ("n", "-", "<CMD>Oil<CR>", opts)

-- quickfix and location list

local function toggle_list (window, open, close)
    return function ()
        local windows = vim.fn.getwininfo ()
        for _, win in pairs (windows) do
            if win[window] == 1 then
                close ()
                return
            end
        end
        open ()
    end
end

vim.keymap.set ("n", "<leader>qo", toggle_list ("quickfix", vim.cmd.copen, vim.cmd.cclose), opts)
vim.keymap.set ("n", "<leader>qn", "<CMD>cnext<CR>", opts)
vim.keymap.set ("n", "<leader>qp", "<CMD>cprevious<CR>", opts)
vim.keymap.set ("n", "<leader>qf", "<CMD>cfirst<CR>", opts)
vim.keymap.set ("n", "<leader>ql", "<CMD>clast<CR>", opts)
vim.keymap.set ("n", "<leader>qO", "<CMD>colder<CR>", opts)
vim.keymap.set ("n", "<leader>qN", "<CMD>cnewer<CR>", opts)
vim.keymap.set ("n", "<leader>lo", toggle_list ("loclist", vim.cmd.lopen, vim.cmd.lclose), opts)
vim.keymap.set ("n", "<leader>ln", "<CMD>lnext<CR>", opts)
vim.keymap.set ("n", "<leader>lp", "<CMD>lprevious<CR>", opts)
vim.keymap.set ("n", "<leader>lf", "<CMD>lfirst<CR>", opts)
vim.keymap.set ("n", "<leader>ll", "<CMD>llast<CR>", opts)
vim.keymap.set ("n", "<leader>lO", "<CMD>lolder<CR>", opts)
vim.keymap.set ("n", "<leader>lN", "<CMD>lnewer<CR>", opts)

-- diagnostics

vim.keymap.set ("n", "<leader>do", toggle_list ("quickfix", function () vim.diagnostic.setqflist { open = true } end, vim.cmd.cclose), opts)
vim.keymap.set ("n", "<leader>dn", function () vim.diagnostic.goto_next () end, opts)
vim.keymap.set ("n", "<leader>dp", function () vim.diagnostic.goto_prev () end, opts)

-- undo breakpoints

vim.keymap.set ("i", ".", ".<C-g>u", opts)
vim.keymap.set ("i", ",", ",<C-g>u", opts)
vim.keymap.set ("i", ";", ";<C-g>u", opts)

-- clear search highlights

vim.keymap.set ({ "i", "n" }, "<ESC>", "<CMD>nohlsearch<CR><ESC>", opts)

-- lsp

vim.api.nvim_create_autocmd ("LspAttach", {
    callback = function ()
        local function filtered_document_symbol (filter)
            vim.lsp.buf.document_symbol ()
            vim.cmd.Cfilter (("[[%s]]"):format (filter))
        end
        local function toggle_inlay_hints ()
            local current = vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
            vim.lsp.inlay_hint.enable (not current, { bufnr = 0 })
        end

        -- TODO: some of these might be set by default in upcoming neovim versions.
        vim.keymap.set ("n", "gd", vim.lsp.buf.definition, opts_buf)
        vim.keymap.set ("n", "gD", vim.lsp.buf.declaration, opts_buf)
        vim.keymap.set ("n", "<leader>gd", "<C-w>}", opts_buf)
        vim.keymap.set ("n", "<leader>gc", "<C-w>z", opts_buf)
        vim.keymap.set ("n", "<leader>gi", vim.lsp.buf.implementation, opts_buf)
        vim.keymap.set ("n", "<leader>gS", vim.lsp.buf.document_symbol, opts_buf)
        vim.keymap.set ("n", "<leader>gW", vim.lsp.buf.workspace_symbol, opts_buf)
        vim.keymap.set ("n", "<leader>gF", function () filtered_document_symbol ("Function") end, opts_buf)
        vim.keymap.set ("n", "<leader>gM", function () filtered_document_symbol ("Module") end, opts_buf)
        vim.keymap.set ("n", "<leader>gT", function () filtered_document_symbol ("Struct") end, opts_buf)
        vim.keymap.set ("n", "<leader>fF", function () vim.lsp.buf.format { async = true } end, opts_buf)
        vim.keymap.set ("n", "<leader>oh", toggle_inlay_hints, opts_buf)
        vim.keymap.set ({ "n", "v" }, "gra", vim.lsp.buf.code_action, opts_buf)
        vim.keymap.set ("n", "grn", vim.lsp.buf.rename, opts_buf)
        vim.keymap.set ("n", "grr", vim.lsp.buf.references, opts_buf)
        vim.keymap.set ("i", "<C-s>", vim.lsp.buf.signature_help, opts_buf)
    end,
})

-- typos

vim.cmd.abbrev { "conenction", "connection" }
vim.cmd.abbrev { "subection", "subsection" }
vim.cmd.abbrev { "subsubection", "subsubsection" }
