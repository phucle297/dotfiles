vim.api.nvim_create_user_command("LspRestartAll", function()
	local clients = vim.lsp.get_clients()
	local names = {}

	for _, client in ipairs(clients) do
		names[client.name] = true
	end

	vim.defer_fn(function()
		for name in pairs(names) do
			vim.lsp.enable(name, false)
			vim.lsp.enable(name, true)
		end
	end, 500)
end, {
	desc = "Restart all LSP servers",
})
