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
  -- 1) サーバ設定を Neovim 本体の登録表に定義
  vim.lsp.config['tsserver'] = {
    name = 'tsserver',
    cmd = { 'npx', 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact', 'javascript.jsx' },

    -- ルート判定（tsconfig.json / package.json / .git のいずれか）
    root_dir = function(fname)
      local root = vim.fs.dirname(vim.fs.find({ 'tsconfig.json', 'package.json', '.git' }, { upward = true, path = fname })[1])
      return root or vim.loop.cwd()
    end,

    -- 旧 on_attach 相当。ここでバッファローカルにキーマップする
    on_attach = function(client, bufnr)
      -- opts は明示的にここで作る（元コードにあった opts を内製化）
      local opts = { buffer = bufnr, silent = true, noremap = true }

      -- 垂直分割で definition を開く関数（元コードを Lua ネイティブに）
      local function open_definition()
        vim.cmd('vsplit')
        vim.cmd('wincmd l')
        vim.lsp.buf.definition()
      end

      vim.keymap.set('n', 'K',  vim.lsp.buf.hover,      opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gd', open_definition,        opts)
    end,
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
