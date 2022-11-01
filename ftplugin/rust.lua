vim.cmd[[packadd rust.vim]]

local opts = { noremap=true, silent=true, buffer=true }

-- keymap
vim.keymap.set('n', 'qq', ':call rustfmt#Format()<CR>', opts)
