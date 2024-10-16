local status, packer = pcall(require, "packer")
if not status then
    return
end

return packer.startup(function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    -- colorscheme:
    use({
        "catppuccin/nvim",
        as = "catppuccin",
        commit = 'a1439ad7c584efb3d0ce14ccb835967f030450fe'
    })

    use('nvim-tree/nvim-web-devicons')

    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })
    use({
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('christoomey/vim-tmux-navigator') -- tmux & split window navigator
    use('theprimeagen/harpoon')
    use('szw/vim-maximizer')              -- maximize and restore the current window

    use('tpope/vim-surround')
    use('vim-scripts/ReplaceWithRegister')
    use('numToStr/Comment.nvim')
    use('nvim-lualine/lualine.nvim')

    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },

            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },

            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'rafamadriz/friendly-snippets' },

            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        }
    })

    -- use({
    --     'HallerPatrick/py_lsp.nvim',
    --     -- Support for versioning
    --     -- tag = "v0.0.1"
    -- })
end)
