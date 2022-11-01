vim.cmd('packadd vim-prettier')

local opts = { noremap=true, silent=true, buffer=true }

vim.keymap.set('n', 'qq', ':PrettierAsync<CR>', opts)
