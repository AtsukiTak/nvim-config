vim.cmd[[packadd rust.vim]]
vim.cmd[[packadd rust-tools.nvim]]

local opts = { noremap=true, silent=true, buffer=true }

-- keymap
vim.keymap.set('n', 'qq', ':call rustfmt#Format()<CR>', opts)

-- 保存時にrustfmtを実行する
vim.g.rustfmt_autosave = 1

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

-- rust-tools.nvim
require'rust-tools'.setup {
  server = {
    on_attach = function (client, bufnr)
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    end,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          features = {},
          target = target
        },
        checkOnSave = true -- falseにしたときどうなるか確認する
      }
    }
  }
}
