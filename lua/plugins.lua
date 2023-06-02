-- akinsho/bufferline関係の設定
require'bufferline'.setup {
  icons = 'numbers',
  closable = false,
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


-- Copilotの設定
-- Copilotはnode 17以下でないと動かない。プロジェクトによっては18以降のバージョンを使用しているので、
-- Copilot用のnodeは明示的にパスを指定する。
vim.g.copilot_node_command = '/Users/takahashiatsuki/.nodenv/versions/16.19.0/bin/node'


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
