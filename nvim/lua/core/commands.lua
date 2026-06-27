vim.api.nvim_create_user_command('PackUpdate', function() vim.pack.update() end, {})

vim.api.nvim_create_user_command('PackClean', function() vim.pack.del() end, {})
