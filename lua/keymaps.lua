local M = {}

function M.setup()
  local kmap_opts = { noremap = true, silent = true }
  vim.g.mapleader = ' '

  local bufcycle = require("bufcycle")
  local terminal = require("terminal")
  local floating = require("floating")
  local winpick = require("winpick")

  -- カーソル移動系
  vim.keymap.set({ 'n', 'v', 's', 'o' }, '<S-h>', '^', kmap_opts)
  vim.keymap.set({ 'n', 'v', 's', 'o' }, '<S-l>', '$', kmap_opts)
  vim.keymap.set({ 'n', 'v', 's', 'o' }, '<C-e>', '$', kmap_opts)

  -- tab管理系
  vim.keymap.set('n', '<leader>tc', ':tabnew<CR>', kmap_opts)
  vim.keymap.set('n', '<leader>tl', ':tabnext<CR>', kmap_opts)
  vim.keymap.set('n', '<leader>th', ':tabprevious<CR>', kmap_opts)
  vim.keymap.set('n', '<leader>tL', ':tabmove +1<CR>', kmap_opts)
  vim.keymap.set('n', '<leader>tH', ':tabmove -1<CR>', kmap_opts)

  -- window管理系
  vim.keymap.set('n', '<C-a><Tab>', '<C-w>w', kmap_opts)
  vim.keymap.set('n', '<C-a><S-Tab>', '<C-w>W', kmap_opts)
  vim.keymap.set('t', '<C-a><Tab>', [[<C-\><C-n><C-w>w]], kmap_opts)
  vim.keymap.set('t', '<C-a><S-Tab>', [[<C-\><C-n><C-w>W]], kmap_opts)
  vim.keymap.set('n', '=', '<C-w>=', kmap_opts)
  vim.keymap.set("n", "<leader>fw", floating.show, kmap_opts)
  vim.keymap.set("n", "<leader>w", function()
    local winid = winpick.pick_window()
    if winid then
      vim.api.nvim_set_current_win(winid)
    end
  end, kmap_opts)

  -- buffer管理系
  vim.keymap.set('n', '<C-n>', bufcycle.next_file_buffer, kmap_opts)
  vim.keymap.set('n', '<C-p>', bufcycle.prev_file_buffer, kmap_opts)
  vim.keymap.set('n', '<C-a>n', bufcycle.next_terminal, kmap_opts)
  vim.keymap.set('n', '<C-a>p', bufcycle.prev_terminal, kmap_opts)
  vim.keymap.set('t', '<C-a>n', bufcycle.next_terminal, kmap_opts)
  vim.keymap.set('t', '<C-a>p', bufcycle.prev_terminal, kmap_opts)

  -- buffer close without window close
  -- 1. file bufferの場合、次のfile bufferを表示
  -- 2. terminal bufferの場合、次のterminal bufferを表示
  vim.keymap.set('n', '<C-q>', function()
    local buf = vim.api.nvim_get_current_buf()
    local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })

    -- windowを閉じずにbufferを削除し、次のfile bufferを表示
    if bt == "" then
      require("mini.bufremove").delete()
      bufcycle.next_file_buffer()
      return
    end

    -- windowを閉じずにbufferを削除し、次のterminal bufferを表示
    if bt == "terminal" then
      local busy, err = terminal.is_terminal_busy(bufnr)
      if busy == nil then
        vim.notify("Failed to inspect terminal: " .. (err or "unknown error"), vim.log.levels.WARN)
        return
      end
      if busy then
        vim.notify("Terminal is still running; buffer not closed", vim.log.levels.WARN)
        return
      end
      require("mini.bufremove").delete()
      bufcycle.next_terminal()
      return
    end

    -- それ以外のbuftypeでは何もしない
  end, kmap_opts)

  -- terminal系
  vim.keymap.set('t', '<C-a><C-[>', [[<C-\><C-n>]], { noremap = true })
  vim.keymap.set('n', '<C-a>c', ':terminal<CR>i', kmap_opts)
  vim.keymap.set('t', '<C-a>c', [[<C-\><C-n>:terminal<CR>i]], kmap_opts)
  vim.keymap.set('t', '<C-a>a', [[<C-a>]], kmap_opts)

  -- lsp系
  vim.keymap.set('n', '<C-f>', vim.diagnostic.open_float, kmap_opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, kmap_opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, kmap_opts)

  -- ESC
  vim.keymap.set('i', '<C-j>', '<ESC>', kmap_opts)
  vim.keymap.set({ 'n', 'v', 's', 'o' }, '<C-j>', '<ESC>', kmap_opts)

  -- Telescope
  vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', kmap_opts)
  vim.keymap.set('n', '<leader>fb', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', kmap_opts)
  vim.keymap.set('n', '<leader>fB', '<cmd>Telescope file_browser<CR>', kmap_opts)
  vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', kmap_opts)
  vim.keymap.set('n', '<leader>b', '<cmd>Telescope buffers<CR>', kmap_opts)

  -- NvimTree
  vim.keymap.set("n", "<leader>ntt", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
  vim.keymap.set("n", "<leader>ntf", ":NvimTreeFindFile<CR>", { desc = "Find file in file explorer" })
  vim.keymap.set("n", "<leader>nth", ":NvimTreeResize -20<CR>", { desc = "Shrink file explorer" })
  vim.keymap.set("n", "<leader>ntl", ":NvimTreeResize +20<CR>", { desc = "Expand file explorer" })
end

return M
