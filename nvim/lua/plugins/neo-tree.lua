return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	config = function()
		local dir_history = {}
		local dir_history_idx = 0
		local current_dir = vim.fn.getcwd()

		local function find_deepest(path, depth)
			depth = depth or 0
			local entries = vim.fn.readdir(path)
			local dirs = vim.tbl_filter(function(e)
				return vim.fn.isdirectory(path .. "/" .. e) == 1
			end, entries)

			if #dirs == 0 then
				return path, depth
			end

			local deepest_path = path
			local deepest_depth = depth

			for _, dir in ipairs(dirs) do
				local candidate_path, candidate_depth = find_deepest(path .. "/" .. dir, depth + 1)
				if candidate_depth > deepest_depth then
					deepest_path = candidate_path
					deepest_depth = candidate_depth
				end
			end

			return deepest_path, deepest_depth
		end

		local function jump_to_deepest(start_dir)
			local deepest, _ = find_deepest(start_dir or current_dir)

			if deepest == start_dir then
				return
			end

			if dir_history_idx < #dir_history then
				dir_history = vim.list_slice(dir_history, 1, dir_history_idx)
			end

			if #dir_history == 0 or dir_history[dir_history_idx] ~= current_dir then
				table.insert(dir_history, current_dir)
			end

			table.insert(dir_history, deepest)
			dir_history_idx = #dir_history
			current_dir = deepest -- update our own tracking

			vim.cmd("Neotree focus dir=" .. deepest)
		end

		local function jump_to_deepest_from_selection()
			local manager = require("neo-tree.sources.manager")
			local state = manager.get_state("filesystem")
			local node = state.tree:get_node()
			local path = node:get_id() -- this is the full path of the highlighted node

			-- if it's a file, use its parent directory
			if node.type == "file" then
				path = vim.fn.fnamemodify(path, ":h")
			end

			jump_to_deepest(path)
		end

		local function dir_history_back()
			if dir_history_idx <= 1 then
				vim.notify("No previous directory", vim.log.levels.INFO)
				return
			end
			dir_history_idx = dir_history_idx - 1
			vim.cmd("Neotree focus dir=" .. dir_history[dir_history_idx])
		end

		local function dir_history_forward()
			if dir_history_idx >= #dir_history then
				vim.notify("No next directory", vim.log.levels.INFO)
				return
			end
			dir_history_idx = dir_history_idx + 1
			vim.cmd("Neotree focus dir=" .. dir_history[dir_history_idx])
		end

		require("neo-tree").setup({
			close_if_last_window = true,
			filesystem = {
				filtered_items = {
					visible = true,
				},
			},
			window = {
				mappings = {
					["f"] = "none",
					["fd"] = function()
						jump_to_deepest_from_selection()
					end,
					["fb"] = dir_history_back,
					["fn"] = dir_history_forward,
				},
			},
		})

		-- global keymaps still work from any buffer
		vim.keymap.set("n", "<leader>fd", function()
			jump_to_deepest_from_selection()
		end, { desc = "Jump to deepest directory" })
		vim.keymap.set("n", "<leader>fb", dir_history_back, { desc = "Directory history back" })
		vim.keymap.set("n", "<leader>fn", dir_history_forward, { desc = "Directory history forward" })

		vim.keymap.set("n", "<C-n>", function()
			local neo_tree_open = false
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local buf = vim.api.nvim_win_get_buf(win)
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
