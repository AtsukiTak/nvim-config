-- init.luaより前に1度だけ実行され、その場合lazy pluginが読み込まれていない
-- エラーが発生するので、lazy pluginが存在するかをチェックし、存在しない場合は
-- 処理を終了する
local has_lazy, lazy = pcall(require, "lazy")
if not has_lazy then
  return
end

-- pyright LSPの設定
require'lspconfig'.pyright.setup{
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
    },
  },
}

-- ruff LSPの設定
require('lspconfig').ruff.setup({
})

-- Disable hover capability from Ruff
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

-- keymap
vim.keymap.set('n', 'qq', function()
  vim.lsp.buf.format({ async = true })
end, { noremap=true, silent=true, buffer=true })

-- :LspStart の実行
vim.cmd("LspStart")
