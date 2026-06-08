return {
	-- Telescope is sort of kind of deprecated. Sadly.
	-- {
	--     'nvim-telescope/telescope.nvim',
	--     tag = '0.1.8',
	--     dependencies = { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' },
	--     config = function()
	--         local builtin = require("telescope.builtin")
	--         vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	--         vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
	--     end
	-- },
	-- {
	--     "nvim-telescope/telescope-ui-select.nvim",
	--     config = function()
	--         require("telescope").setup({
	--             extensions = {
	--                 ["ui-select"] = {
	--                     require("telescope.themes").get_dropdown {
	--                     }
	--                 }
	--             }
	--         })
	--         require("telescope").load_extension("ui-select")
	--     end
	-- },

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			picker = {
				enabled = true,
				sources = {
					files = { hidden = true },
					grep = { hidden = true },
				},
				layout = {
					layout = {
						box = "horizontal",
						width = 0.8,
						height = 0.9,
						border = "none",
						{
							box = "vertical",
							width = 0.4,
							{ win = "list", border = "rounded" },
							{ win = "input", height = 1, border = "rounded" },
						},
						{
							win = "preview",
							title = "{preview}",
							border = "rounded",
						},
					},
				},
			},
		},
		keys = {
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Live Grep",
			},
		},
		init = function()
			-- replaces telescope-ui-select
			vim.ui.select = function(items, opts, on_choice)
				Snacks.picker.select(items, opts, on_choice)
			end
		end,
	},
}
