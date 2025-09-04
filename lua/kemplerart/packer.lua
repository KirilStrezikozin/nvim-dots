local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use({ 'wbthomason/packer.nvim' })

    -- colorscheme:
    use({
        "catppuccin/nvim",
        as = "catppuccin",
        commit = 'a1439ad7c584efb3d0ce14ccb835967f030450fe'
    })

    use('nvim-tree/nvim-web-devicons')

    use('wakatime/vim-wakatime')

    use({ 'rose-pine/neovim', name = 'rose-pine' })

    use({
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
            })
        end,
    })

    use({ 'mikebentley15/vim-pio' })

    use({
        'chomosuke/typst-preview.nvim',
        tag = 'v1.*',
        config = function()
            require 'typst-preview'.setup {
                dependencies_bin = {
                    ['tinymist'] = 'tinymist',
                    ['websocat'] = 'websocat',
                },
            }
        end,
    })

    use({ 'previm/previm' })
    use({ 'tyru/open-browser.vim', as = 'open-browser' })
    use({ 'aklt/plantuml-syntax' })

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

    use('f-person/git-blame.nvim')
    use('lewis6991/gitsigns.nvim')

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
            { 'hrsh7th/cmp-cmdline' },

            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'rafamadriz/friendly-snippets' },

            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        }
    })

    use({
        "kdheepak/lazygit.nvim",
        requires = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").load_extension("lazygit")
        end,
    })

    use('lervag/vimtex')

    use('lambdalisue/vim-suda')

    -- use({
    --     'HallerPatrick/py_lsp.nvim',
    --     -- Support for versioning
    --     -- tag = "v0.0.1"
    -- })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
