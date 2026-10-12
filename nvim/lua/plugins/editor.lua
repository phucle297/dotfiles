local excluded_dirs = {
	".git",
	".cache",
	".dart_tool",
	".gradle",
	".godot",
	".mypy_cache",
	".next",
	".nox",
	".nuxt",
	".output",
	".pytest_cache",
	".ruff_cache",
	".svelte-kit",
	-- ".terraform",
	".tox",
	".venv",
	".zig-cache",
	"__pycache__",
	"bin",
	"bower_components",
	"build",
	"CMakeFiles",
	"cmake-build-*",
	"coverage",
	"deps",
	"DerivedData",
	"dist",
	"htmlcov",
	"node_modules",
	"obj",
	"out",
	"Pods",
	"target",
	"venv",
	"vendor",
	"zig-out",
	"_build",
}

return {
	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPre",
		opts = {
			render = "background",
			enable_hex = true,
			enable_short_hex = true,
			enable_rgb = true,
			enable_hsl = true,
			enable_hsl_without_function = true,
			enable_ansi = true,
			enable_var_usage = true,
			enable_tailwind = true,
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files({
						hidden = true,
						no_ignore = true,
					})
				end,
				desc = "Find files (cwd)",
			},
			{
				"<leader>fF",
				function()
					require("telescope.builtin").find_files({
						cwd = LazyVim.root(),
						hidden = true,
						no_ignore = true,
					})
				end,
				desc = "Find files (cwd)",
			},
			{
				"<leader>fo",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "Find recently opened files",
			},
			{
				"<leader>fw",
				function()
					require("telescope.builtin").live_grep({
						additional_args = { "--hidden" },
					})
				end,
				desc = "Grep (cwd)",
			},
			{
				"<leader>fW",
				function()
					require("telescope.builtin").live_grep({
						cwd = LazyVim.root(),
						additional_args = { "--hidden" },
					})
				end,
				desc = "Grep (Root Dir)",
			},
			{
				"<leader>fe",
				function()
					local builtin = require("telescope.builtin")
					builtin.diagnostics()
				end,
				desc = "Lists Diagnostics for all open buffers or a specific buffer",
			},
			{
				"<leader>fr",
				function()
					require("telescope.builtin").lsp_references({
						initial_mode = "normal",
					})
				end,
				desc = "Find references",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			opts.defaults = opts.defaults or {}
			opts.defaults.vimgrep_arguments = opts.defaults.vimgrep_arguments
				or vim.deepcopy(require("telescope.config").values.vimgrep_arguments)

			local find_command = { "rg", "--files", "--hidden", "--no-ignore" }
			for _, dir in ipairs(excluded_dirs) do
				vim.list_extend(find_command, { "--glob", "!**/" .. dir .. "/**" })
				vim.list_extend(opts.defaults.vimgrep_arguments, { "--glob", "!**/" .. dir .. "/**" })
			end
			vim.list_extend(opts.defaults.vimgrep_arguments, { "--hidden", "--no-ignore" })

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
				mappings = {
					n = {},
				},
			})
			opts.pickers = {
				find_files = {
					find_command = find_command,
				},
				diagnostics = {
					theme = "ivy",
					initial_mode = "normal",
					layout_config = {
						preview_cutoff = 9999,
					},
				},
			}
			opts.extensions = {
				file_browser = {
					theme = "dropdown",
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = true,
					mappings = {
						-- your custom insert mode mappings
						["n"] = {
							-- your custom normal mode mappings
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
							["<C-u>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_previous(prompt_bufnr)
								end
							end,
							["<C-d>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_next(prompt_bufnr)
								end
							end,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
						},
					},
				},
			}
			telescope.setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")
		end,
	},

	{
		"kazhala/close-buffers.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>th",
				function()
					require("close_buffers").delete({ type = "hidden" })
				end,
				"Close Hidden Buffers",
			},
			{
				"<leader>tu",
				function()
					require("close_buffers").delete({ type = "nameless" })
				end,
				"Close Nameless Buffers",
			},
		},
	},

	{
		"saghen/blink.cmp",
		opts = {
			completion = {
				menu = {
					winblend = vim.o.pumblend,
				},
			},
			signature = {
				window = {
					winblend = vim.o.pumblend,
				},
			},
		},
	},

	{
		"gaelph/logsitter.nvim",
		keys = {
			{
				"<leader>lg",
				"<cmd>:lua require('logsitter').log()<CR>",
				desc = "Log current node",
			},
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("logsitter").setup({
				path_format = "default",
				prefix = "🚀",
				separator = "->",
			})
		end,
	},

	{
		enabled = true,
		"folke/flash.nvim",
		---@type Flash.Config
		opts = {
			search = {
				-- forward = true,
				-- multi_window = false,
				-- wrap = false,
				incremental = true,
			},
		},
		key = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
}
