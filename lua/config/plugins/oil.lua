-- Edit and explore the filesystem like a regular buffer.
-- https://github.com/stevearc/oil.nvim 
return {
    {
	'stevearc/oil.nvim',
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	-- Optional dependencies
	-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	config = function()
	    require("oil").setup {
		skip_confirm_for_simple_edits = true,
	      	watch_for_changes = false,
	      	view_options = {
		    show_hidden = true,
	      	},
	    }

	    vim.keymap.set("n", "-", "<CMD>Oil<CR>")
	end,
    },
}
