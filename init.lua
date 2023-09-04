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


-- akinsho/bufferline関係の設定
require'barbar'.setup {
  icons = {
    buffer_index = true,
    filetype = { enabled = false },
    button = '',
    modified = { button = '' },
  },
  insert_at_end = true
}
-- 色の設定
vim.cmd[[hi BufferVisible ctermfg=250 ctermbg=253]]
vim.cmd[[hi BufferVisibleIndex ctermfg=250 ctermbg=253]]
vim.cmd[[hi BufferVisibleSign ctermfg=250 ctermbg=253]]
vim.cmd[[hi BufferVisibleMod ctermbg=253]]
vim.cmd[[hi BufferVisibleTarget ctermbg=253]]
-- 新しいタブを開いた時に毎回re-orderする
vim.cmd[[au BufRead * BufferOrderByBufferNumber]]
-- Clolose buffer
vim.api.nvim_set_keymap('n', '<C-q>', '<Cmd>BufferClose<CR>', kmap_opts)


-- Copilotの設定
-- Copilotはnode 17以下でないと動かない。プロジェクトによっては18以降のバージョンを使用しているので、
-- Copilot用のnodeは明示的にパスを指定する。
vim.g.copilot_node_command = '/Users/takahashiatsuki/.nodenv/versions/17.9.1/bin/node'


-- TreeSitter関係の設定
-- NOTE: TreeSitterは特定のバージョンのlanguage parserとのみ協調するので
-- TreeSitterのバージョンを上げた時は、各種language parserのバージョンも上げる.
-- そのためのコマンドは `:TSUpdate`.
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = "all",

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- treesitterでmouseが有効化されてしまうので無効にする
vim.cmd[[set mouse=]]

-- WGSL用TreeSitterの設定
vim.filetype.add({extension = {wgsl = "wgsl"}})
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.wgsl = {
  install_info = {
    url = "https://github.com/szebniok/tree-sitter-wgsl",
    files = {"src/parser.c"}
  },
}
