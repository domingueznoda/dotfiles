-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Tab navigation using tabs
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })

-- Line comment
vim.keymap.set("n", "<leader>/", function()
  local line = vim.fn.line(".")
  require("mini.comment").toggle_lines(line, line)
end, { desc = "Comment line" })

-- Selection comment
vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Comment selection" })
