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

-- Keymapのセットアップ
require("keymaps").setup()

-- カスタムコマンドのセットアップ
vim.api.nvim_create_user_command("Sqa", function()
  require("safeclose").safe_close()
end, {})

-- Colorのセットアップ
require("color").setup()

-- Pluginのセットアップ
require("plugins").setup()

-- Terminal buffer関連のセットアップ
require("terminal").setup()

-- デフォルトのlayout
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(function()
      require("nvim-tree.api").tree.open({ find_file = true })
      vim.cmd("wincmd p")
    end)
  end,
})
