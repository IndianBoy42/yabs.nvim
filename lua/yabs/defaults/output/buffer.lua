local function make_scratch_buffer(height, position)
    if not height then
        height = ""
    end
    if not position then
        position = ""
    else
        position = position .. " "
    end
    vim.cmd(position .. height .. "new")

    vim.opt_local.buftype = "nofile"
    vim.opt_local.bufhidden = "wipe"
    vim.opt_local.buflisted = false
    vim.opt_local.swapfile = false
    vim.opt_local.wrap = false

    return vim.fn.bufnr()
end

local function append_to_buffer(buffer, lines)
    vim.api.nvim_buf_set_lines(buffer, -2, -2, false, lines)
end

local bufnr

local function on_exit()
end

local function on_read(lines)
    lines[#lines] = nil
    append_to_buffer(bufnr, lines)
end

local function buffer(cmd)
    bufnr = make_scratch_buffer(14, "bot")

    require("yabs/util").async_command(cmd, {
        on_exit = on_exit,
        on_read = vim.schedule_wrap(on_read)
    })
end

-- local function buffer(cmd)
--     vim.cmd("bot 13new")
--     vim.fn.termopen(cmd)
--     vim.cmd("starti")
-- end

return buffer