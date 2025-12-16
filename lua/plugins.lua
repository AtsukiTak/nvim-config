local M = {}

function M.setup()
  -- Lazy.nvim bootstrap
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    {
      -- colorscheme
      "sainnhe/everforest",
      lazy = false,
      priority = 1000,
      config = function()
        vim.g.everforest_enable_italic = true
        vim.cmd.colorscheme("everforest")
      end,
    },
    {
      -- nerdfont icons
      "nvim-tree/nvim-web-devicons",
      opts = {},
    },
    {
      -- luaの便利関数collection
      "nvim-lua/plenary.nvim",
    },
    {
      -- GitHub Copilot
      "github/copilot.vim",
    },
    {
      -- 構文解析
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      branch = "master",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "javascript", "json", "json5", "lua", "rust", "toml", "tsx", "typescript", "yaml" },
          sync_install = false,
          auto_install = true,
          highlight = { enable = true },
        })
        vim.cmd([[set mouse=]])
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldenable = false
      end,
    },
    {
      -- interactive search for files, buffers
      "nvim-telescope/telescope.nvim",
      tag = "0.1.3",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("telescope").load_extension("file_browser")
      end,
    },
    {
      -- make status bar cool
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({
          options = { theme = "everforest" },
        })
      end,
    },
    {
      -- buffer deleteしたときにwindowを消さない
      "nvim-mini/mini.bufremove",
      config = function()
        require("mini.bufremove").setup({ silent = true })
      end,
    },
    {
      -- tabpage manager
      "nanozuki/tabby.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
        require("tabby").setup({
          preset = "tab_only",
          option = {
            lualine_theme = "everforest",
          },
        })
      end,
    },
    {
      "sindrets/diffview.nvim",
    },
    {
      "lewis6991/gitsigns.nvim",
      opts = {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            gs.nav_hunk("next")
          end, "Next hunk")
          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            gs.nav_hunk("prev")
          end, "Prev hunk")

          map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
          map("n", "<leader>hr", gs.reset_hunk, "Reset hunk (変更を破棄)")
          map("n", "<leader>hu", gs.undo_stage_hunk, "Undo last stage hunk")

          map({ "v" }, "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "Stage selection")
          map({ "v" }, "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "Reset selection")

          map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>hb", gs.blame_line, "Blame line")
          map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
          map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
          map("n", "<leader>hd", gs.diffthis, "Diff this")
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, "Diff vs HEAD")
          map("n", "<leader>ht", gs.toggle_deleted, "Toggle deleted")
          map("n", "<leader>hh", gs.select_hunk, "Select hunk (VISUALに入る)")
        end,
      },
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
      end,
    },
    {
      "prettier/vim-prettier",
      ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    },
    {
      "rust-lang/rust.vim",
      lazy = true,
    },
  })
end

return M
