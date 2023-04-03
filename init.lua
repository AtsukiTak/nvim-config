vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

vim.o.number = true
vim.o.ambiwidth = "double"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.autoindent = true
vim.o.expandtab = true -- tabを入力した時にspaceで代替する
vim.o.list = true -- tab文字などを可視化する
-- 高速化のための設定
vim.o.showcmd = false
vim.o.ruler = false
vim.o.scrolljump = 5
vim.o.lazyredraw = true

vim.cmd("colorscheme molokai")

-- ## Keymap
local kmap_opts = { noremap=true, silent=true }

-- カーソル移動系
vim.api.nvim_set_keymap('', '<S-h>', '^', kmap_opts)
vim.api.nvim_set_keymap('', '<S-l>', '$', kmap_opts)
vim.api.nvim_set_keymap('', '<C-e>', '$', kmap_opts)

-- window管理系
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>w', kmap_opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>W', kmap_opts)
vim.api.nvim_set_keymap('n', '=', '<C-w>=', kmap_opts)

-- buffer管理系
vim.api.nvim_set_keymap('n', '<C-n>', ':bnext<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<C-p>', ':bprev<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<C-q>', ':bp|bd #<CR>', kmap_opts)

-- lsp系
vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>lua vim.diagnostic.open_float()<CR>', kmap_opts)

-- その他
vim.api.nvim_set_keymap('i', '<C-j>', '<ESC>', kmap_opts)
vim.api.nvim_set_keymap('', '<C-j>', '<ESC>', kmap_opts)


-- plugin関係の設定
require'plugins'
