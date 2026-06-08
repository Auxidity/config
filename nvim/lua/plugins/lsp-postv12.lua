-- plugins/lsp.lua
return {
	-- Mason just for installing binaries, nothing else
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	-- nvim-lspconfig still needed for server configs
	{ "neovim/nvim-lspconfig" },

	{
		"j-hui/fidget.nvim",
		opts = {},
	},

	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"folke/lazydev.nvim",
		},
		opts = {
			keymap = {
				preset = "none",
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<CR>"] = { "select_and_accept", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
			},
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},

	-- LSP setup - native 0.11+ style
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp", "folke/snacks.nvim" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "markdown" },
				callback = function(e)
					if vim.bo[e.buf].buftype == "nofile" then
						vim.treesitter.stop(e.buf)
					end
				end,
			})

			-- LspAttach: keymaps wired to snacks.picker instead of telescope
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", function()
						Snacks.picker.lsp_definitions()
					end, "Goto Definition")
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")
					map("gr", function()
						Snacks.picker.lsp_references()
					end, "Goto References")
					map("gi", function()
						Snacks.picker.lsp_implementations()
					end, "Goto Implementation")
					map("grt", function()
						Snacks.picker.lsp_type_definitions()
					end, "Goto Type Definition")
					map("gO", function()
						Snacks.picker.lsp_symbols()
					end, "Document Symbols")
					map("gW", function()
						Snacks.picker.lsp_workspace_symbols()
					end, "Workspace Symbols")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local aug = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = aug,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = aug,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(e)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = e.buf })
							end,
						})
					end

					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay Hints")
					end
				end,
			})

			-- Native 0.11+ server configs
			vim.lsp.config("clangd", {
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--background-index",
					"--pch-storage=memory",
					"--clang-tidy",
					"--completion-style=detailed",
				},
			})

			vim.lsp.config("rust_analyzer", { capabilities = capabilities })

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
					},
				},
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					local root_dir =
						vim.fs.dirname(vim.fs.find({ "pom.xml", "gradlew", ".git", ".project" }, { upward = true })[1])
					if not root_dir then
						return
					end

					local workspace = vim.fn.expand("~/.cache/jdtls/") .. vim.fn.fnamemodify(root_dir, ":t") -- just the project folder name

					vim.lsp.start({
						name = "jdtls",
						cmd = {
							"/usr/lib/jvm/jdk-21.0.10-oracle-x64/bin/java",
							"-jar",
							vim.fn.expand("~/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
							"-configuration",
							vim.fn.expand("~/.local/share/jdtls/config_linux"),
							"-data",
							workspace,
						},
						root_dir = root_dir,
						capabilities = require("blink.cmp").get_lsp_capabilities(),
						settings = {
							java = {
								configuration = {
									runtimes = {
										{
											name = "JavaSE-1.8",
											path = "/usr/lib/jvm/temurin-8-jdk-amd64",
											default = true,
										},
									},
								},
							},
						},
					})
				end,
			})

			vim.lsp.enable({ "clangd", "rust_analyzer", "lua_ls" })
		end,
	},

	-- Autoformat, unchanged
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				end
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
}
