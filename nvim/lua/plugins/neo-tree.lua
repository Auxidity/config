return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    lazy = false,
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true,
            filesystem = {
                filtered_items = {
                    visible = true,
                },
            },
        })
        vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
        vim.keymap.set('n', '<S-n>', ':Neotree close<CR>')
    end,

}
