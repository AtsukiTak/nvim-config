vim.cmd('packadd vim-prettier')

local opts = { noremap=true, silent=true }

vim.api.nvim_set_keymap('n', 'qq', ':PrettierAsync<CR>', opts)
