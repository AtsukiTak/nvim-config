function open_definition()
  vim.cmd('vsplit')
  vim.cmd('wincmd l')
  vim.cmd('lua vim.lsp.buf.definition()')
end

vim.cmd('packadd vim-prettier')

local opts = { noremap=true, silent=true, buffer=true }

vim.keymap.set('n', 'qq', ':PrettierAsync<CR>', opts)

-- LSPの設定
-- MEMO: neovimからTypescriptのLSPを利用するにはtsserverだけでなく
-- typescript-language-serverも必要。これはtsserverがLanguageServerProtocolを
-- サポートしていないため。
-- プロジェクト事情でtypescript-language-serverをプロジェクトのdependencyに
-- 入れられないこともあるので、今はglobalにインストールしている。
require'lspconfig'.tsserver.setup {
  on_attach = function(client)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gd', open_definition, opts)
  end
}

require'lspconfig'.diagnosticls.setup {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx"
  },
  init_options = {
    file_types = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint'
    },
    linters = {
      eslint = {
        sourceName = "eslint",
        command = "./node_modules/.bin/eslint",
        rootPatterns = { '.git' },
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '${message} [${ruleId}]',
          security = 'severity',
        },
        securities = {
          [2] = 'error',
          [1] = 'warning',
        }
      }
    }
  }
}

