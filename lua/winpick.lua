local M = {}

M.pick_window = function(opts)
  -- window-picker の罫線が 1 セル幅になるよう、実行中だけ ambiwidth を single にする
  local prev = vim.o.ambiwidth
  vim.o.ambiwidth = "single"
  local ok, result = pcall(require("window-picker").pick_window, opts)
  vim.o.ambiwidth = prev

  if not ok then
    vim.notify("window-picker failed: " .. tostring(result), vim.log.levels.ERROR)
    return nil
  end

  return result
end

M.lsp_definition = function()
  local src_win = vim.api.nvim_get_current_win()
  local src_buf = vim.api.nvim_get_current_buf()
  local from = vim.fn.getpos('.')
  from[1] = src_buf
  local tagname = vim.fn.expand('<cword>')

  local target_win = M.pick_window()
  if not target_win or not vim.api.nvim_win_is_valid(target_win) then
    return
  end

  vim.lsp.buf.definition({
    on_list = function(options)
      if not options.items or vim.tbl_isempty(options.items) then
        vim.notify('No locations found', vim.log.levels.INFO)
        return
      end

      if #options.items == 1 then
        if vim.api.nvim_win_is_valid(src_win) then
          vim.api.nvim_win_call(src_win, function()
            vim.cmd("normal! m'")
          end)
          vim.fn.settagstack(src_win, {
            items = {
              { tagname = tagname, from = from },
            },
          }, 't')
        end

        local item = options.items[1]
        local bufnr = item.bufnr or vim.fn.bufadd(item.filename)
        vim.bo[bufnr].buflisted = true
        if vim.api.nvim_win_is_valid(target_win) then
          vim.api.nvim_win_set_buf(target_win, bufnr)
          vim.api.nvim_win_set_cursor(target_win, { item.lnum, item.col - 1 })
          vim._with({ win = target_win }, function()
            vim.cmd('normal! zv')
          end)
          vim.api.nvim_set_current_win(target_win)
        end
        return
      end

      vim.fn.setqflist({}, ' ', {
        title = options.title or 'LSP locations',
        items = options.items,
      })
      vim.cmd('botright copen')
    end,
  })
end

return M
