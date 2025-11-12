local M = {}

function M.safe_close()
  local current_buf = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()
  local closed = 0

  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
      local mod = vim.api.nvim_get_option_value("modified", { buf = buf })

      -- ターミナルバッファの実行中判定
      local is_terminal = (bt == "terminal")
      local is_running = false
      if is_terminal then
        local job_id = vim.b[buf].terminal_job_id
        if job_id and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
          is_running = true
        end
      end

      -- 閉じない条件:
      -- 1. modified=true
      -- 2. 実行中のterminal
      if not mod and not is_running then
        vim.api.nvim_buf_delete(buf, { force = true })
        closed = closed + 1
      end
    end
  end

  vim.notify("Closed " .. closed .. " unused buffers", vim.log.levels.INFO)
end

return M

