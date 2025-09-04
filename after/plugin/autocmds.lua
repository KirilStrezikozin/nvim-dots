-- Create group to assign commands.
-- Ported from <https://stackoverflow.com/questions/77147995/setting-up-formatters-in-neovim-with-mason-lsp-zero>
-- "clear = true" must be set to prevent loading an
-- auto-command repeatedly every time a file is resourced.
local autocmd_group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true })

-- Set up gersemi CMakeLists formatter.
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "CMakeLists.txt", "*.cmake" },
    desc = "Auto-format CMakeLists files after saving",
    callback = function()
        local fileName = vim.api.nvim_buf_get_name(0)
        vim.cmd(":silent !gersemi -i " .. fileName)
    end,
    group = autocmd_group,
})
