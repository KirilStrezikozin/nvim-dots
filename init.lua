vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")

vim.o.shiftwidth = 4
vim.o.clipboard = "unnamedplus"
vim.o.number = true
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.signcolumn = "yes"
vim.o.tabstop = 4

vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

vim.keymap.set("n", "yp", "yyp")

vim.cmd(":hi statusline guibg=NONE")

-- Prior to nvim 0.11
vim.diagnostic.config {
	float = {
		border = "rounded",
	},
}
