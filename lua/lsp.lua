local opts = { noremap=true, silent=true }

local set_lsp_keymap = function()
  vim.api.nvim_set_keymap('n', '<C-e>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_set_keymap('n', 'T', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
end

local set_lsp_command = function()
  vim.cmd(":command! LspRename :lua vim.lsp.buf.rename()")
end

local on_attach_lsp = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
end

return {
  set_lsp_keymap = set_lsp_keymap,
  set_lsp_command = set_lsp_command,
  on_attach_lsp = on_attach_lsp,
}
