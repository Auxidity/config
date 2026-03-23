return {
	"junegunn/vim-easy-align",
	lazy = false,
	config = function()
		vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
		vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")
	end,
}
