local M = {}

M.spec = {
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup({
                disable_filetype = { 'TelescopePrompt', 'text' },
            })

            -- For '(' after function or method item
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end
    },
    {
        'tommcdo/vim-lion',
        event = 'LazyFile',
    },
    {
        'norcalli/nvim-colorizer.lua',
        event = 'LazyFile',
        config = function()
            require("colorizer").setup()
        end,
    },

}

return M
