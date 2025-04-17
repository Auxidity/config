-- rust-tools.lua or similar file
return {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Ensure you're using the correct version
    lazy = false,
    ["rust-analyzer"] = {
        cargo = {
            allFeatures = true,
        },
    },
    config = function()
    end
}

--[[
        local bufnr = vim.api.nvim_get_current_buf()
        vim.g.rustaceanvim = {
            tools = {
            },
            server = {
                on_attach = function(client, bufnr)
                    if client.name == "rust_analyzer" then
                        vim.keymap.set('n', '<leader>a', ':RustLsp codeAction <CR>', { silent = true, buffer = bufnr })
                        vim.keymap.set('n', 'K', ':RustLsp hover actions<CR>', { silent = true, buffer = bufnr })
                        vim.keymap.set('n', '<leader>R', ':RustLsp runnables<CR>', { silent = true, buffer = bufnr })
                        vim.keymap.set('n', '<leader>dd', ':RustLsp debuggables<CR>', { silent = true, buffer = bufnr })
                    end
                end,
                default_settings = {
                    ['rust-analyzer'] = {
                    },
                },
            },
            dap = {
            },
        }
--]]
