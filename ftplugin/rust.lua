vim.cmd[[packadd rust.vim]]
vim.cmd[[packadd rust-tools.nvim]]

local opts = { noremap=true, silent=true, buffer=true }

-- keymap
vim.keymap.set('n', 'qq', ':call rustfmt#Format()<CR>', opts)


-- rust-toolsの設定
-- rust-toolsはInlay Hintが便利なので入れてる
require'rust-tools'.setup {
  server = {
    on_attach = function (client, bufnr)
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    end,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          features = "all"
        }
      }
    }
  }
}
