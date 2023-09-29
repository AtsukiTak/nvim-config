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

vim.cmd("colorscheme molokai")

-- ## Keymap
local kmap_opts = { noremap=true, silent=true }
vim.g.mapleader = ' '
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
vim.api.nvim_set_keymap('n', '<leader>a"', 'ciw""<ESC>P', kmap_opts) -- カーソル下の単語をダブルクォートで囲む
vim.api.nvim_set_keymap('n', "<leader>a'", "ciw''<ESC>P", kmap_opts) -- カーソル下の単語をシングルクォートで囲む

-- Lazy.nvimの設定
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
    "romgrk/barbar.nvim",
    init = function() vim.g.barbar_auto_setup = false end,
    config = function()
      require("barbar").setup({
        icons = {
          buffer_index = true,
          filetype = { enabled = false },
          button = '',
          modified = { button = '' },
        },
        insert_at_end = true
      })
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
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- NOTE: TreeSitterは特定のバージョンのlanguage parserとのみ協調するので
    -- TreeSitterのバージョンを上げた時は、各種language parserのバージョンも上げる.
    build = ":TSUpdate",
    config = function()
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
      -- Tree-sitter based folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end
  },
  {
    "github/copilot.vim",
    config = function()
      -- Copilotはnode 17以下でないと動かない。プロジェクトによっては18以降のバージョンを使用しているので、
      -- Copilot用のnodeは明示的にパスを指定する。
      vim.g.copilot_node_command = '/Users/takahashiatsuki/.nodenv/versions/17.9.1/bin/node'
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.3",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("telescope").load_extension("file_browser")
      vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', kmap_opts)
      vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', kmap_opts)
      vim.api.nvim_set_keymap('n', '<leader>fB', '<cmd>Telescope file_browser<CR>', kmap_opts)
      vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>Telescope live_grep<CR>', kmap_opts)
    end
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    config = function()
      -- 保存時にrustfmtを実行する
      vim.g.rustfmt_autosave = 1
      -- keymap
      local opts = { noremap=true, silent=true, buffer=true }
      vim.keymap.set('n', 'qq', ':call rustfmt#Format()<CR>', opts)
    end
  },
  {
    "hashivim/vim-terraform",
    enabled = false,
  },
  {
    "neovim/nvim-lspconfig",
    ft = {"typescript", "typescriptreact"},
    config = function()
      local function open_definition()
        vim.cmd('vsplit')
        vim.cmd('wincmd l')
        vim.cmd('lua vim.lsp.buf.definition()')
      end

      -- MEMO: neovimからTypescriptのLSPを利用するにはtsserverだけでなく
      -- typescript-language-serverも必要。これはtsserverがLanguageServerProtocolを
      -- サポートしていないため。
      -- プロジェクト事情でtypescript-language-serverをプロジェクトのdependencyに
      -- 入れられないこともあるので、今はglobalにインストールしている。
      local opts = { noremap=true, silent=true, buffer=true }
      require'lspconfig'.tsserver.setup {
        on_attach = function(client)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gd', open_definition, opts)
        end
      }
    end
  },
  {
    "neovim/nvim-lspconfig",
    ft = {"rust"},
    config = function()
      -- rustのconfigを読み込み、targetを取得する
      local target = nil
      local bufnr = vim.api.nvim_get_current_buf()
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      while filepath ~= "" do
        local dir = filepath:match("(.*/)") -- ファイルのディレクトリを取得
        local config_path = dir .. ".cargo/config.toml"
        local file = io.open(config_path, "r")
        if file then
          while true do -- 1行ずつ読み込む
            local line = file:read("*l")
            if line == nil then
              break
            end
            target = line:match('target%s*=%s*"([^"]+)"') -- target = "wasm32-unknown-unknown" のような行を取得
            if target then
              break
            end
          end
          file:close()
        end
        filepath = dir:sub(1, -2) -- 最後の/を削除して次のディレクトリへ（dirが/のときはnilになる）
      end

      require("lspconfig").rust_analyzer.setup {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              features = {},
              target = target
            },
            checkOnSave = true -- falseにしたときどうなるか確認する
          }
        },
        on_attach = function()
          local opts = { noremap=true, silent=true, buffer=true }
          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        end
      }
    end
  },
  {
    "prettier/vim-prettier",
    ft = {"typescript", "typescriptreact", "javascript"},
    config = function()
      vim.keymap.set('n', 'qq', ':PrettierAsync<CR>', opts)
    end
  }
})

