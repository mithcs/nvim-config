local M = {}

-- requires refactoring.....

local function lsp_setup()
    local lspconfig = require('lspconfig')
    local configs = require('lspconfig.configs')
    local on_attach = require('plugins.lsp_opts').on_attach

    -- -----------------------
    -- Custom lsp -- {{{
    -- -----------------------
    if not configs.qml6_lsp then
        configs.qml6_lsp = {
            default_config = {
                cmd = { 'qmlls6' },
                filetypes = { 'qml' },
                root_dir = function(fname)
                    return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
                end,
                settings = {},
            },
        }
    end

    if not configs.dartls then
        configs.dartls = {
            default_config = {
                cmd = { 'dart', 'language-server', '--protocol=lsp' },
                filetypes = { 'dart' },
                init_options = {
                    closingLabels = true,
                    flutterOutline = true,
                    onlyAnalyzeProjectsWithOpenFiles = true,
                    outline = true,
                    suggestFromUnimportedLibraries = true
                },
                root_dir = function(fname)
                    return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
                end,
                settings = {
                    dart = {
                        completeFunctionCalls = true,
                        showTodos = true
                    }
                },
            },
        }
    end

    require 'lspconfig'.dartls.setup({
        on_attach = on_attach
    })

    -- -----------------------
    -- Rust
    -- -----------------------
    lspconfig.rust_analyzer.setup({
        autostart = false,
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_dir = function(fname)
            local cargo_crate_dir = lspconfig.util.root_pattern 'Cargo.toml' (fname)
            local cmd = 'cargo metadata --no-deps --format-version 1'
            if cargo_crate_dir ~= nil then
                cmd = cmd .. ' --manifest-path ' .. lspconfig.util.path.join(cargo_crate_dir, 'Cargo.toml')
            end
            local cargo_metadata = vim.fn.system(cmd)
            local cargo_workspace_dir = nil
            if vim.v.shell_error == 0 then
                cargo_workspace_dir = vim.fn.json_decode(cargo_metadata)['workspace_root']
            end
            return cargo_workspace_dir
                or cargo_crate_dir
                or lspconfig.util.root_pattern 'rust-project.json' (fname)
                or lspconfig.util.find_git_ancestor(fname)
        end,
        settings = {
            ['rust-analyzer'] = {}
        }
    })
    -- }}}

    require('mason-lspconfig').setup_handlers({
        function(server)
            local opts = {
                on_attach = on_attach,
            }

            if server == 'volar' then
                opts.filetypes = { 'vue', 'javascript', 'typescript' }
                opts.init_options = {
                    vue = {
                        hybridMode = false,
                    },
                }
            end

            lspconfig[server].setup(opts)
        end,
    })
end

-- -----------------------
-- Completions
-- -----------------------
local function cmp_setup()
    local cmp = require('cmp')
    local luasnip_status_ok, luasnip = pcall(require, 'luasnip')
    if not luasnip_status_ok then
        return
    end

    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
        sources = {
            { name = 'luasnip', keyword_length = 1 },
            { name = 'path' },
            { name = 'nvim_lsp' },
            { name = 'buffer',  keyword_length = 1 },
        },

        mapping = cmp.mapping.preset.insert({
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),

            ['<C-n>'] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end,
            ['<C-p>'] = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end
        }),

        vim.diagnostic.config({
            virtual_text = {
                prefix = '▎', -- Could be '●', '▎', 'x'
            },
            signs = true,
            severity_sort = false,
        }),

        window = {
            documentation = cmp.config.window.bordered(),
        },
        experimental = {
            ghost_text = true,
        }
    })
end

-- Toggle completions
local function toggle_autocomplete()
    local cmp = require('cmp')
    local current_setting = cmp.get_config().completion.autocomplete
    if current_setting and #current_setting > 0 then
        cmp.setup({ completion = { autocomplete = false } })
        print('Autocomplete disabled')
    else
        cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
        print('Autocomplete enabled')
    end
end

vim.api.nvim_create_user_command('NvimCmpToggle', toggle_autocomplete, {})

vim.api.nvim_set_keymap('n', '<leader>nt', ':NvimCmpToggle<CR>', { noremap = true, silent = true })


-- -----------------------
-- Setup lsp servers
-- -----------------------
M.spec = {
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        config = cmp_setup,
        dependencies = {
            {
                'neovim/nvim-lspconfig',
                event = 'LazyFile',
                config = lsp_setup,
                dependencies = {
                    {
                        'williamboman/mason.nvim',
                        dependencies = { 'williamboman/mason-lspconfig.nvim' },
                        config = function()
                            require('mason').setup()
                            require('mason-lspconfig').setup({
                                ensure_installed = { 'lua_ls' },
                            })
                        end,
                    },
                    { 'j-hui/fidget.nvim', opts = {} },
                },
            },
            { 'hrsh7th/cmp-nvim-lsp' },
            {
                'L3MON4D3/LuaSnip',
                version = 'v2.3',
                dependencies = {
                    { 'rafamadriz/friendly-snippets' },
                    { 'saadparwaiz1/cmp_luasnip' },
                },
            },
            {
                'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
                config = function()
                    vim.diagnostic.config({
                        virtual_text = false,
                    })
                    require('lsp_lines').setup()
                    vim.keymap.set(
                        'n',
                        'tl',
                        require('lsp_lines').toggle,
                        { desc = 'Toggle lsp_lines' }
                    )
                end
            },
        },
    },
}

return M
