local function get_target()
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
end

local function setup_lsp()
  require("lspconfig").rust_analyzer.setup {
    -- rust-analyzerはstableのみサポートしているため、プロジェクトでstable以外のバージョンを使っている場合は
    -- rust-analyzerの起動ができない。そのため、rust-analyzerの起動時にRUSTUP_TOOLCHAIN=stableを設定する。
    -- これは使用しているrustのバージョンにかかわらず、rust-analyzerの対象にはstableを使うという意味。
    cmd = { "env", "RUSTUP_TOOLCHAIN=stable", "rust-analyzer" },
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          target = get_target()
        },
        checkOnSave = true -- falseにしたときどうなるか確認する
      }
    },
    on_attach = function()
      print("rust lsp on_attach")
      local opts = { noremap=true, silent=true, buffer=true }
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    end
  }
  -- :LspStart の実行
  -- 本来これがなくてもLSPが起動するはずだが、なぜか起動しないので一応実行しておく
  vim.cmd("LspStart")
end

return {
  setup_lsp = setup_lsp
}
