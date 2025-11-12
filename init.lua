vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- netrwを無効化する
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.number = true
vim.o.ambiwidth = "double"
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.autoindent = true
vim.o.expandtab = true -- tabを入力した時にspaceで代替する
vim.o.list = true -- tab文字などを可視化する
vim.o.showcmd = false
vim.o.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize' -- セッション保存
vim.o.showtabline = 2

-- ## Keymap
local kmap_opts = { noremap=true, silent=true }
vim.g.mapleader = ' '
-- カーソル移動系
vim.api.nvim_set_keymap('', '<S-h>', '^', kmap_opts)
vim.api.nvim_set_keymap('', '<S-l>', '$', kmap_opts)
vim.api.nvim_set_keymap('', '<C-e>', '$', kmap_opts)
-- tab管理系
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabnew<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<leader>tl', ':tabnext<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<leader>th', ':tabprevious<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<leader>tL', ':tabmove +1<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<leader>tH', ':tabmove -1<CR>', kmap_opts)
-- window管理系
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>w', kmap_opts)
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>W', kmap_opts)
vim.api.nvim_set_keymap('n', '=', '<C-w>=', kmap_opts)
-- buffer管理系
local bufcycle = require("bufcycle") -- 自作のluaスクリプト
vim.keymap.set('n', '<C-n>', bufcycle.next_file_buffer, kmap_opts)
vim.keymap.set('n', '<C-p>', bufcycle.prev_file_buffer, kmap_opts)
vim.keymap.set('n', '<C-t>n', bufcycle.next_terminal, kmap_opts)
vim.keymap.set('n', '<C-t>p', bufcycle.prev_terminal, kmap_opts)
-- terminal系
vim.keymap.set('t', '<C-t>', [[<C-\><C-n>]], { noremap = true })
-- lsp系
vim.keymap.set('n', '<C-f>', vim.diagnostic.open_float, kmap_opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, kmap_opts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, kmap_opts)
-- ESC
vim.api.nvim_set_keymap('i', '<C-j>', '<ESC>', kmap_opts)
vim.api.nvim_set_keymap('', '<C-j>', '<ESC>', kmap_opts)
-- Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<leader>fB', '<cmd>Telescope file_browser<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', kmap_opts)
vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Telescope buffers', kmap_opts)
-- bufremove
vim.keymap.set('n', '<C-q>', function()
  require("mini.bufremove").delete()
end, kmap_opts)

-- カスタムコマンド
vim.api.nvim_create_user_command("SClose", function()
  require("safeclose").safe_close()
end, {})

-- Lazy.nvimの導入
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- installするpluginを記述
require("lazy").setup({
  {
    -- colorscheme
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = true
      vim.cmd.colorscheme('everforest')
    end
  },
  {
    -- nerdfont icons
    "nvim-tree/nvim-web-devicons",
    opts = {}
  },
  {
    -- luaの便利関数collection
    "nvim-lua/plenary.nvim"
  },
  {
    -- 構文解析
    "nvim-treesitter/nvim-treesitter",
    -- NOTE: TreeSitterは特定のバージョンのlanguage parserとのみ協調するので
    -- TreeSitterのバージョンを上げた時は、各種language parserのバージョンも上げる.
    build = ":TSUpdate",
    branch = "master",
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the four listed parsers should always be installed)
        ensure_installed = {  "javascript", "json", "json5", "lua", "rust", "toml", "tsx", "typescript", "yaml" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        -- ignore_install = { "ada", "jsonc", "fusion", "ipkg" },

        highlight = {
          enable = true,
        },
      }
      -- treesitterでmouseが有効化されてしまうので無効にする
      vim.cmd[[set mouse=]]
      -- Tree-sitter based folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end
  },
  {
    -- interactive search for files, buffers
    "nvim-telescope/telescope.nvim",
    tag = "0.1.3",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("telescope").load_extension("file_browser")
    end
  },
  {
    -- make status bar cool
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup({
        options = { theme = 'everforest' },
      })
    end
  },
  {
    -- buffer deleteしたときにwindowを消さない
    "nvim-mini/mini.bufremove",
    config = function()
      require("mini.bufremove").setup({
        silent = true
      })
    end
  },
  {
    -- tabpage manager
    'nanozuki/tabby.nvim',
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require('tabby').setup({
        preset = 'tab_only',
        option = {
          lualine_theme = 'everforest',
        },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    -- New typescript language server (replacement of typescript-language-server)
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact" },
    opts = {},
    config = function()
      require("typescript-tools").setup({})
    end
  },
  {
    "prettier/vim-prettier",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },
  {
    "rust-lang/rust.vim",
    lazy = true,
  }
})

