local status, _ = pcall(require, "previm")
if not status then
    return
end

vim.g.previm_show_header = 0
