local options = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>fmt', ":!black .<CR>", options)
