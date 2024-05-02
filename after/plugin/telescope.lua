local status_telescope, telescope = pcall(require, "telescope")
local status_builtin, builtin     = pcall(require, "telescope.builtin")

if not status_builtin or not status_telescope then
    return
end

telescope.setup({
    pickers = {
        find_files = {
            theme = "dropdown",
        }
    }
})

vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>pg", builtin.git_files, {})
vim.keymap.set('n', '<leader>e', "<cmd>Telescope harpoon marks<CR>")
vim.keymap.set("n", "<leader>pzf", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
