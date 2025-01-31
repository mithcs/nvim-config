local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
--     vim.fn.system({
--         "git",
--         "clone",
--         "--filter=blob:none",
--         "https://github.com/folke/lazy.nvim.git",
--         "--branch=stable", -- latest stable release
--         lazypath,
--     })
-- end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
    return
end

-- Start setup
lazy.setup({
    spec = {
        -- Treesitter
        { "nvim-treesitter/nvim-treesitter" },

        -- Catppuccin
        { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

        -- Telescope
        {
            'nvim-telescope/telescope.nvim', tag = '0.1.8',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },

        -- Colorizer
        {
            'norcalli/nvim-colorizer.lua',
            config = function()
                require("colorizer").setup()
            end,
        },

        -- Auto pairs
        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            opts = {} -- this is equalent to setup({}) function
        },

        -- Comment
        {
            'numToStr/Comment.nvim',
            opts = {
                -- This is required, probably if there is no separate config file
            },
            lazy = false,
        },

        -- Flutter-tools
        {
            'nvim-flutter/flutter-tools.nvim',
            lazy = false,
            dependencies = {
                'nvim-lua/plenary.nvim',
            },
            config = true,
        },

        -- Telescope-undo
        {
            "debugloop/telescope-undo.nvim",
            dependencies = {
                {
                    "nvim-telescope/telescope.nvim",
                    dependencies = { "nvim-lua/plenary.nvim" },
                },
            },
            keys = {
                {
                    "<leader>u",
                    "<C>Telescope undo<cr>",
                    desc = "undo history",
                },
            },
            config = function()
                require("telescope").load_extension("undo")
            end,
        },

        -- Telescope ui select
        {
            'nvim-telescope/telescope-ui-select.nvim',
            config = function()
                require("telescope").load_extension("ui-select")
            end,
        },


        -- LSP
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

        {'neovim/nvim-lspconfig'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/nvim-cmp'},
    },

    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "tohtml",
                "gzip",
                "tutor",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "osc52",
                "zipPlugin",
                "rplugin",
            },
        },
    },
})
