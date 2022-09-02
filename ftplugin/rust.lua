vim.cmd[[packadd rust.vim]]

local opts = { noremap=true, silent=true }

-- keymap
vim.api.nvim_set_keymap('n', 'qq', ':call rustfmt#Format()<CR>', opts)
