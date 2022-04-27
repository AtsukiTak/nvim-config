local opts = { noremap = true, silent = true }

-- カーソル移動系
vim.api.nvim_set_keymap('', '<S-h>', '^', opts)
vim.api.nvim_set_keymap('', '<S-l>', '$', opts)

-- window管理系
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>w', opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>W', opts)
vim.api.nvim_set_keymap('n', '=', '<C-w>=', opts)

-- buffer管理系
vim.api.nvim_set_keymap('n', '<C-n>', ':bnext<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-p>', ':bprev<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-q>', ':bp|bd #<CR>', opts)

-- その他
vim.api.nvim_set_keymap('i', '<C-j>', '<ESC>', opts)
vim.api.nvim_set_keymap('', '<C-j>', '<ESC>', opts)
vim.api.nvim_set_keymap('n', 'qq', ':call rustfmt#Format()<CR>', opts)

-- telescope
vim.keymap.set('n', '<space>ff', require('telescope.builtin').find_files, opts)
vim.keymap.set('n', '<space>fb', require('telescope.builtin').buffers, opts)
