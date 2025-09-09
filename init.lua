vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

vim.o.colorcolumn = "80,120"
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.spell = true
vim.o.tabstop = 4
vim.o.undofile = true
vim.o.wrap = false
vim.o.autochdir = true

vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

vim.keymap.set("n", "yp", "yyp")

-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.cmd(":hi statusline guibg=NONE")

-- Prior to nvim 0.11
vim.diagnostic.config {
  float = {
    border = "rounded",
  },
}

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})

-- https://www.youtube.com/watch?v=5PIiKDES_wc
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local create_floating_terminal = function(opts)
  opts = opts or {}
  local w = opts.width or math.floor(vim.o.columns * 0.8)
  local h = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - w) / 2)
  local row = math.floor((vim.o.lines - h) / 2)

  local buf = nil
  if not vim.api.nvim_buf_is_valid(opts.buf) then
    buf = vim.api.nvim_create_buf(false, true)
  else
    buf = opts.buf
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = w,
    height = h,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  })

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_terminal({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command("ToggleFloatingTerminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<C-h>", toggle_terminal, { desc = "[T]oggle Floating Terminal" })
