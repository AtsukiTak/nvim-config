vim.cmd[[packadd rust.vim]]
vim.cmd[[packadd nvim-lspconfig]]

lsp = require'lsp'

local opts = { noremap=true, silent=true }

-- rust-analyzerの有効化
require'lspconfig'.rust_analyzer.setup({
  on_attach = lsp.on_attach_lsp,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        loadOutDirsFromCheck = true
      }
    }
  }
})

-- keymap
lsp.set_lsp_keymap()
vim.api.nvim_set_keymap('n', 'qq', ':call rustfmt#Format()<CR>', opts)

-- command
lsp.set_lsp_command()
