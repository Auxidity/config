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
		-- could use :Neotree toggle, but the default reveal was right (could've changed, dont care the code below works) and I dont like it
		vim.keymap.set("n", "<C-n>", function()
			local neo_tree_open = false
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local buf = vim.api.nvim_win_get_buf(win)
				-- :set filetype? returns neo-tree on the window, so search based on that
				local bt = vim.api.nvim_buf_get_option(buf, "filetype")
				if bt == "neo-tree" then
					neo_tree_open = true
					break
				end
			end

			if neo_tree_open then
				vim.cmd("Neotree close")
			else
				vim.cmd("Neotree filesystem reveal left")
			end
		end, { desc = "Toggle Neotree" })
	end,
}
