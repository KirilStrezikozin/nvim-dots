local lsp = require("lsp-zero")
lsp.preset('recommended')

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls",
        "tsserver",
        "pylsp",
        "pyright",
        "rust_analyzer",
        "clangd",
    },
}

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.setup()

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),

        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil,

        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-F>'] = cmp.mapping.scroll_docs(-4),

        ['<C-c>'] = cmp.mapping.close(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' },
    }, {
        { name = 'buffer', keyword_length = 2 },
        { name = 'path' },
        { name = 'calc' },
    }),
    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = '',
                nvim_lua = '',
                buffer   = '',
                calc     = 'λ',
                path     = '󰝰',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})

local lspconfig = require('lspconfig')
local lspconfigs = require('lspconfig/configs')

function Filter(arr, func)
    -- Filter in place
    -- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
    local new_index = 1
    local size_orig = #arr
    for old_index, v in ipairs(arr) do
        if func(v, old_index) then
            arr[new_index] = v
            new_index = new_index + 1
        end
    end
    for i = new_index, size_orig do arr[i] = nil end
end

function Filter_diagnostics(diagnostic)
    -- Only filter out Pyright stuff for now
    -- if diagnostic.source ~= "Pyright" then
    --     return true
    -- end

    if diagnostic.message == 'Call expression not allowed in type expression' then
        return false
    elseif diagnostic.message == 'Argument of type "List[List[float]] | Tuple[Tuple[float, float, float, float], Tuple[float, float, float, float], Tuple[float, float, float, float], Tuple[float, float, float, float]] | Matrix" cannot be assigned to parameter "operands" of type "_ArrayLikeFloat_co" in function "einsum"' then
        return false
    elseif diagnostic.message == 'No overloads for "einsum" match the provided arguments' then
        return false
    elseif diagnostic.message == 'Cannot access member "bm_props" for type "Scene"     Member "bm_props" is unknown' then
        return false
    end

    if string.match(diagnostic.message, '"_.+" is not accessed') then
        return false
    end

    return true
end

function Custom_on_publish_diagnostics(a, params, client_id, c, config)
    Filter(params.diagnostics, Filter_diagnostics)
    vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    Custom_on_publish_diagnostics, {})

lspconfig.clangd.setup {}

lspconfig.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                autopep8 = {
                    enabled = true,
                    ignore = { 'F722', 'W503' },
                },
                pycodestyle = {
                    enabled = false,
                    -- ignore = { 'F722', 'W503' },
                },
                pyflakes = {
                    enabled = false,
                    -- ignore = { 'F722', 'W503' },
                },
                flake8 = {
                    enabled = true,
                    ignore = { 'F722', 'W503' },
                }
            }
        }
    }
}

lspconfig.pyright.setup {
    settings = {
        -- disableLanguageServices = true,

        python = {
            analysis = {
                typeCheckingMode = 'on',
            },
            -- disable = { 'F722', 'W503' },
        }
    }
}

lspconfig.rust_analyzer.setup {
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
            },
            check = {
                command = "clippy",
            },
            diagnostics = {
                enable = true,
            }
        }
    }
}

lspconfig.gopls.setup({
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
})

if not lspconfigs.golangcilsp then
    lspconfigs.golangcilsp = {
        default_config = {
            cmd = { 'golangci-lint-langserver' },
            root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
            init_options = {
                command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
            }
        },
    }
end
lspconfig.golangci_lint_ls.setup {
    filetypes = { 'go', 'gomod' }
}

lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
