local M = {}

function M.setup()
  local kmap_opts = { noremap = true, silent = true }
  vim.g.mapleader = ' '

  local bufcycle = require("bufcycle")
  local terminal = require("terminal")
  local floating = require("floating")

  -- カーソル移動系
  vim.api.nvim_set_keymap('', '<S-h>', '^', kmap_opts)
  vim.api.nvim_set_keymap('', '<S-l>', '$', kmap_opts)
  vim.api.nvim_set_keymap('', '<C-e>', '$', kmap_opts)

  -- tab管理系
  vim.api.nvim_set_keymap('n', '<leader>tc', ':tabnew<CR>', kmap_opts)
  vim.api.nvim_set_keymap('n', '<leader>tl', ':tabnext<CR>', kmap_opts)
  vim.api.nvim_set_keymap('n', '<leader>th', ':tabprevious<CR>', kmap_opts)
  vim.api.nvim_set_keymap('n', '<leader>tL', ':tabmove +1<CR>', kmap_opts)
  vim.api.nvim_set_keymap('n', '<leader>tH', ':tabmove -1<CR>', kmap_opts)

  -- window管理系
  vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>w', kmap_opts)
  vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>W', kmap_opts)
  vim.api.nvim_set_keymap('n', '=', '<C-w>=', kmap_opts)
  vim.keymap.set("n", "<leader>fw", floating.show, kmap_opts)

  -- buffer管理系
  vim.keymap.set('n', '<C-n>', '<cmd>bnext<CR>', kmap_opts)
  vim.keymap.set('n', '<C-p>', '<cmd>bprevious<CR>', kmap_opts)
  vim.keymap.set('n', '<C-f>n', bufcycle.next_filte_buffer, kmap_opts)
  vim.keymap.set('n', '<C-f>p', bufcycle.prev_filte_buffer, kmap_opts)
  vim.keymap.set('n', '<C-t>n', bufcycle.next_terminal, kmap_opts)
  vim.keymap.set('n', '<C-t>p', bufcycle.prev_terminal, kmap_opts)
  vim.keymap.set('n', '<C-q>', function()
    local buf = vim.api.nvim_get_current_buf()
    local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
    if bt == "terminal" then
      terminal.remove_terminal_if_idle(buf)
      return
    end
    -- windowを閉じずにbufferを削除
    require("mini.bufremove").delete()
  end, kmap_opts)

  -- terminal系
  vim.keymap.set('t', '<C-t>', [[<C-\><C-n>]], { noremap = true })
  vim.api.nvim_set_keymap('n', '<C-t>c', ':terminal<CR>i', kmap_opts)

  -- lsp系
  vim.keymap.set('n', '<C-f>', vim.diagnostic.open_float, kmap_opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, kmap_opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, kmap_opts)

  -- ESC
  vim.api.nvim_set_keymap('i', '<C-j>', '<ESC>', kmap_opts)
  vim.api.nvim_set_keymap('', '<C-j>', '<ESC>', kmap_opts)

  -- Telescope
  vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', kmap_opts)
  vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', kmap_opts)
  vim.api.nvim_set_keymap('n', '<leader>fB', '<cmd>Telescope file_browser<CR>', kmap_opts)
  vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', kmap_opts)
  vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Telescope buffers<CR>', kmap_opts)
end

return M
