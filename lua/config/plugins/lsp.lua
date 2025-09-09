-- https://github.com/neovim/nvim-lspconfig
return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap
      keymap = { preset = 'default' },

      appearance = {
        nerd_font_variant = 'mono'
      },

      signature = { enabled = true }
    },
    -- opts_extend = { "sources.default" }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      })

      lspconfig.tinymist.setup({
        capabilities = capabilities,
        settings = {
          formatterMode = "typstyle",
          exportPdf = "onType",
          semanticTokens = "disable",
        },
      })

      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      lspconfig.cmake.setup({
        capabilities = capabilities,
      })

      lspconfig.nixd.setup({
        capabilities = capabilities,
        settings = {
          nixd = {
            formatting = {
              command = { "nixfmt" },
              -- command = { "nix", "fmt", "--", "--" }, -- this timeouts
            },
          },
        },
      })

      -- Prior to nvim 0.11 (where they are the defaults)
      -- https://github.com/neovim/neovim/pull/28650
      vim.keymap.set("n", "grn", vim.lsp.buf.rename)
      vim.keymap.set("n", "gra", vim.lsp.buf.code_action)
      vim.keymap.set("n", "grr", vim.lsp.buf.references)
      vim.keymap.set("n", "gri", vim.lsp.buf.implementation)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
      vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol)
      vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help)
      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

      -- Command for "NixFormat" that calls `nix fmt` on the current buffer.
      local call_nix_fmt = function(buf)
        local filename = vim.api.nvim_buf_get_name(buf)

        vim.api.nvim_buf_call(buf, function()
          vim.cmd("write")
        end)

        local obj = vim.system(
          { "nix", "fmt", filename }, { text = true }
        ):wait()

        if obj.code ~= 0 then
          vim.notify(
            "nix fmt failed: " .. (obj.stderr or "error"),
            vim.log.levels.ERROR
          )
          return
        end

        if not vim.api.nvim_buf_is_valid(buf) then return end
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("edit!")
          vim.notify(
            "nix fmt has formatted the file",
            vim.log.levels.INFO
          )
        end)
      end

      local lsp_keymaps = function(buf)
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc })
        end

        map("n", "grn", vim.lsp.buf.rename, "[R]e[n]ame")
        map({ "n", "x" }, "gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction")
        map("n", "grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("n", "gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

        --  In C this would take you to the header.
        map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map("n", "gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map("n", "gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          local buf = args.buf

          -- In case Telescope is not installed, default LSP keymaps remain.
          pcall(lsp_keymaps, buf)

          -- `nixd` timeouts if `nix fmt` is used as its formatting command.
          -- Provide a "NixFormat" command that will call `nix fmt` on
          -- the current buffer, if it is a *.nix file. Note that `nix fmt`
          -- evaluates and parses *.nix files, which is much slower than just
          -- running a formatter directly.
          if vim.bo.filetype == "nix" then
            vim.api.nvim_buf_create_user_command(
              buf, "NixFormat", function() call_nix_fmt(buf) end,
              { desc = "Run nix fmt on the current file" })
          end

          if client.supports_method("textDocument/formatting", nil) then
            -- Format the current buffer on save.
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = buf, id = client.id })
              end,
            })
          end
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
