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

return M
