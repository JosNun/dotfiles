local utils = require("config.utils")

-- Hot reload config
vim.keymap.set("n", "<leader>rr", utils.reload_config, { desc = "Reload config" })

-- Quickfix navigation (useful for LSP diagnostics, grep results, etc.)
vim.keymap.set("n", "<C-n>", ":cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-m>", ":cprevious<CR>", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>a", ":cclose<CR>", { desc = "Close quickfix list" })
