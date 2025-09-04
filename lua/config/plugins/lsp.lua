-- https://github.com/neovim/nvim-lspconfig
return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").lua_ls.setup {
				settings = {
					Lua = {
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
			}

			-- Prior to nvim 0.11
			-- https://github.com/neovim/neovim/pull/28650
			vim.keymap.set("n", "grn", vim.lsp.buf.rename)
			vim.keymap.set("n", "gra", vim.lsp.buf.code_action)
			vim.keymap.set("n", "grr", vim.lsp.buf.references)
			vim.keymap.set("n", "gri", vim.lsp.buf.implementation)
			vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol)
			vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help)

			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end
				end,
			})

			local border = "rounded"

			-- Prior to nvim 0.11
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
				vim.lsp.handlers.hover, {
					border = border,
				}
			)

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
				vim.lsp.handlers.signature_help, {
					border = border,
				}
			)
		end,
	},
}
