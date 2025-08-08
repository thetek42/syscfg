local opts = { noremap = true, silent = true }
local opts_buf = { noremap = true, silent = true, buffer = true }
local opts_expr = { noremap = true, silent = true, expr = true }

vim.g.mapleader = " "

-- movement
vim.keymap.set ("n", "j", [[ v:count == 0 ? 'gj' : 'j' ]], opts_expr)
vim.keymap.set ("n", "k", [[ v:count == 0 ? 'gk' : 'k' ]], opts_expr)

-- buffers
vim.keymap.set ("n", "<S-h>", "<CMD>bprevious<CR>", opts)
vim.keymap.set ("n", "<S-l>", "<CMD>bnext<CR>", opts)
vim.keymap.set ("n", "<M-h>", "<CMD>bfirst<CR>", opts)
vim.keymap.set ("n", "<M-l>", "<CMD>blast<CR>", opts)

-- windows
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

-- popup menu
vim.keymap.set ("i", "<C-j>", [[ pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>" ]], opts_expr)
vim.keymap.set ("i", "<C-k>", [[ pumvisible() ? "\<C-p>" : "\<C-k>" ]], opts_expr)

-- undo breakpoints
vim.keymap.set ("i", ".", ".<C-g>u", opts)
vim.keymap.set ("i", ",", ",<C-g>u", opts)
vim.keymap.set ("i", ";", ";<C-g>u", opts)

-- clear search highlights
vim.keymap.set ({ "i", "n" }, "<ESC>", "<CMD>nohlsearch<CR><ESC>", opts)

-- oil
vim.keymap.set ("n", "-", "<CMD>Oil<CR>", opts)

-- options
local function opt_toggle (option)
  return function ()
    vim.opt_local[option] = not vim.opt_local[option]
  end
end
vim.keymap.set ("n", "<leader>ts", opt_toggle "spell", opts)
vim.keymap.set ("n", "<leader>tw", opt_toggle "wrap", opts)
vim.keymap.set ("n", "<leader>tW", opt_toggle "linebreak", opts)

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

local function grep_cursor_word ()
  local mode = vim.fn.mode ()
  local search
  if mode == "n" then
    search = vim.fn.expand ("<cword>")
  elseif mode == "v" then
    search = vim.fn.getline ("'<", "'>")[1]
  else
    return
  end
  vim.cmd ("silent lgrep \"" .. search .. "\"")
  vim.cmd ("let @/ = '" .. search .. "'")
  vim.cmd ("set hlsearch")
  vim.cmd ("lopen")
end

local function open_diagnostics ()
  vim.diagnostic.setqflist { open = true }
end

vim.keymap.set ("n", "<leader>oq", toggle_list ("quickfix", vim.cmd.copen, vim.cmd.cclose), opts)
vim.keymap.set ("n", "<leader>ol", toggle_list ("loclist", vim.cmd.lopen, vim.cmd.lclose), opts)
vim.keymap.set ("n", "<leader>od", toggle_list ("quickfix", open_diagnostics, vim.cmd.cclose), opts)
vim.keymap.set ("n", "<leader>ow", grep_cursor_word, opts)

-- language server
vim.api.nvim_create_autocmd ("LspAttach", {
  callback = function ()
    local function toggle_inlay_hints ()
      local current = vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
      vim.lsp.inlay_hint.enable (not current, { bufnr = 0 })
    end

    vim.keymap.set ("n", "gd", vim.lsp.buf.definition, opts_buf)
    vim.keymap.set ("n", "gD", vim.lsp.buf.declaration, opts_buf)
    vim.keymap.set ("n", "grp", "<C-w>}", opts_buf) -- open in preview window
    vim.keymap.set ("n", "gro", "<C-w>z", opts_buf) -- close preview window
    vim.keymap.set ("n", "grf", function () vim.lsp.buf.format { async = true } end, opts_buf)
    vim.keymap.set ("n", "]d", function () vim.diagnostic.jump { count = 1, float = true } end, opts)
    vim.keymap.set ("n", "[d", function () vim.diagnostic.jump { count = -1, float = true } end, opts)
    vim.keymap.set ("n", "<leader>th", toggle_inlay_hints, opts_buf)
  end,
})
