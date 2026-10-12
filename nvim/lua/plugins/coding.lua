return {
	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},
	{
		"max397574/better-escape.nvim",
		opts = {
			timeout = vim.o.timeoutlen, -- after `timeout` passes, you can press the escape key and the plugin will ignore it
			default_mappings = true, -- setting this to false removes all the default mappings
			mappings = {
				i = {
					j = {
						k = "<Esc>",
					},
				},
				c = {
					j = {
						k = "<C-c>",
					},
				},
				t = {
					j = {
						k = "<C-\\><C-n>",
					},
				},
				v = {
					j = {
						k = "<Esc>",
					},
				},
				s = {
					j = {
						k = "<Esc>",
					},
				},
			},
		},
		config = function(_, opts)
			-- lua, default settings
			require("better_escape").setup(opts)
		end,
	},
}
