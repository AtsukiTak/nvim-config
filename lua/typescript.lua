local function setup_lsp()
  -- MEMO: neovimからTypescriptのLSPを利用するにはtsserverだけでなく
  -- typescript-language-serverも必要。これはtsserverがLanguageServerProtocolを
  -- サポートしていないため。
  -- プロジェクト事情でtypescript-language-serverをプロジェクトのdependencyに
  -- 入れられないこともあるので、今はglobalにインストールしている。
  local opts = { noremap=true, silent=true, buffer=true }
  require'lspconfig'.tsserver.setup {
    on_attach = function(client)
      local function open_definition()
        vim.cmd('vsplit')
        vim.cmd('wincmd l')
        vim.cmd('lua vim.lsp.buf.definition()')
      end
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gd', open_definition, opts)
    end
  }

  -- Biome(formatter)の設定
  -- "@biomejs/biome" がインストールされていることが前提
  require'lspconfig'.biome.setup{}

  -- :LspStart の実行
  -- 本来これがなくてもLSPが起動するはずだが、なぜか起動しないので一応実行しておく
  vim.cmd("LspStart")

end

return {
  setup_lsp = setup_lsp
}
