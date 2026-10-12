return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",

		config = function()
			local ts = require("nvim-treesitter")

			local parsers = {
				"astro",
				"cmake",
				"cpp",
				"css",
				"fish",
				"gitignore",
				"go",
				"graphql",
				"http",
				"java",
				"javascript",
				"php",
				"rust",
				"scss",
				"sql",
				"svelte",
				"tsx",
				"typescript",

				-- useful for Neovim config
				"lua",
				"vim",
				"vimdoc",
				"query",

				-- markdown / MDX
				"markdown",
				"markdown_inline",
			}

			-- Install missing parsers
			ts.install(parsers)

			-- Enable Tree-sitter for supported filetypes
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft)

					if lang then
						pcall(vim.treesitter.start, args.buf, lang)
					end
				end,
			})

			-- MDX
			vim.filetype.add({
				extension = {
					mdx = "mdx",
				},
			})

			vim.treesitter.language.register("markdown", "mdx")
		end,
	},
}
