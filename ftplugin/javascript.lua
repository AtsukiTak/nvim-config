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
    "vim-prettier",
  }
})

-- keymap
-- Lazy.nvimのconfigでkeymapを設定すると、pluginがloadされたbufferにしか設定されない。
-- そのため、ここで設定する。
vim.keymap.set('n', 'qq', ':PrettierAsync<CR>', opts)
