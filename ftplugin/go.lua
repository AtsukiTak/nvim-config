-- init.luaより前に1度だけ実行され、その場合lazy pluginが読み込まれていない
-- エラーが発生するので、lazy pluginが存在するかをチェックし、存在しない場合は
-- 処理を終了する
local has_lazy, lazy = pcall(require, "lazy")
if not has_lazy then
  return
end

lazy.load({
  wait = true,
  plugins = {
    "nvim-lspconfig",
  }
})

-- LSPの設定
require'lspconfig'.gopls.setup{}
