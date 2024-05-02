vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '<+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "n", "nzz")
vim.keymap.set('n', "N", "Nzz")

-- jump to the last edited line
vim.keymap.set('n', "rr", "'.zz")

-- quickly replace the current word with register = viwp
vim.keymap.set('n', "gh", "viwp")

vim.keymap.set('n', "yp", "yyp")

-- pasting and yanking without updating the register
vim.keymap.set("v", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>S", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>s", ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

vim.keymap.set("n", "<C-b>", "<C-a>")

vim.keymap.set("n", "<leader>sv", "<C-w>v")     -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s")     -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=")     -- equalize splits
vim.keymap.set("n", "<leader>sx", ":close<CR>") -- close a split

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader><leader>", "<cmd>source<CR>")
