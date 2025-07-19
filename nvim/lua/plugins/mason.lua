return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                -- Enable these on per project basis.
                -- ensure_installed = { "lua_ls", "ts_ls", "eslint" },
                ensure_installed = { "lua_ls" },
                -- I have kept this at false, might be because of it working funnily with rustaceanvim? Flip as neccesary assuming project level installation of nvim
                automatic_installation = true
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig.lua_ls.setup({ capabilities = capabilities })
            lspconfig.ts_ls.setup({ capabilities = capabilities })
            --lspconfig.rust_analyzer.setup({})

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local bufopts = { noremap = true, silent = true }
                    vim.notify(client.name)

                    if client.name == "rust-analyzer" then
                        vim.keymap.set('n', '<leader>ca', ':RustLsp codeAction <CR>', bufopts)
                        vim.keymap.set('n', 'K', ':RustLsp hover actions<CR>', bufopts)
                        vim.keymap.set('n', '<leader>R', ':RustLsp runnables<CR>', bufopts)
                        vim.keymap.set('n', '<leader>D', ':RustLsp debuggables<CR>', bufopts)

                        if client:supports_method('textDocument/definition') then
                            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                        end

                        if client:supports_method('textDocument/declaration') then
                            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                        end
                        return
                    end
                    --[[
                    --The above is a workaround to get some keymaps from the Rustaceanvim plugin. Its the ones I care about. It doesn't make Rustaceanvim work as intended, since we're supposed to skip over nvim-lspconfig entirely on rust.
                    --However, it does give keymaps to a few things we care about, such as run / debug & better CA & hover. Configure this more if need be
                    --]]

                    if client:supports_method('textDocument/implementation') then
                        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                    end

                    if client:supports_method('textDocument/definition') then
                        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                    end

                    if client:supports_method('textDocument/declaration') then
                        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    end

                    if client:supports_method('textDocument/hover') then
                        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                    end

                    if client:supports_method('textDocument/signatureHelp') then
                        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                    end

                    if client:supports_method('workspace/didChangeWorkspaceFolders') then
                        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                    end

                    if client:supports_method('textDocument/typeDefinition') then
                        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
                    end
                    if client:supports_method('textDocument/rename') then
                        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
                    end

                    if client:supports_method('textDocument/codeAction') then
                        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
                    end
                    if client:supports_method('textDocument/references') then
                        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                    end
                    if client:supports_method('textDocument/formatting') then
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                            end,
                        })
                    end
                end,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                callback = function(args)
                    -- Get the detaching client
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    -- Remove the autocommand to format the buffer on save, if it exists
                    if client:supports_method('textDocument/formatting') then
                        vim.api.nvim_clear_autocmds({
                            event = 'BufWritePre',
                            buffer = args.buf,
                        })
                    end
                end,
            })
        end
    }
}
