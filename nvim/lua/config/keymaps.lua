-- Y to EOL
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Better paste behavior
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Better window navigation
vim.keymap.set("n", "<CA-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<CA-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<CA-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<CA-l>", "<C-w>l", { desc = "Move to right window" })

-- Splitting & Resizing
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick file navigation
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- LSP keymaps
vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'LSP Format' })
vim.keymap.set('n', '<leader>lb', ':make<CR>', { desc = 'LSP Build' })
vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', { desc = 'Omnifunc', silent = true, noremap = true })


-- Alternative navigation (more intuitive)
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', { desc = 'Close tab' })

-- Tab moving
vim.keymap.set('n', '<leader>tm', ':tabmove<CR>', { desc = 'Move tab' })
vim.keymap.set('n', '<leader>t>', ':tabmove +1<CR>', { desc = 'Move tab right' })
vim.keymap.set('n', '<leader>t<', ':tabmove -1<CR>', { desc = 'Move tab left' })

-- Tab jumping
vim.keymap.set('n', '<leader>tp', ':tabprevious<CR>', { desc = 'Jump previous tab' })
vim.keymap.set('n', '<leader>tn', ':tabNext<CR>', { desc = 'Jump next tab' })

-- Close buffer
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Smart close buffer/tab' })

-- Scroll through pum and show corresponding documentation
-- lua vim.lsp.buf.hover({ offset_x = 25 })
vim.cmd([[inoremap <expr> <Tab> pumvisible() ? '<Down>' : '<Tab>']])
vim.cmd([[inoremap <expr> <S-Tab> pumvisible() ? '<Up>' : '<S-Tab>']])

-- QuickFix
vim.keymap.set('n', '<leader>qd', '<CMD>lua vim.diagnostic.setqflist()<CR>',
  { desc = 'Open Diagnostic on Quickfix List' })
vim.keymap.set('n', '<leader>qj', '<CMD>cnext<CR>', { desc = 'Scroll down Quickfix List' })
vim.keymap.set('n', '<leader>qk', '<CMD>cprev<CR>', { desc = 'Scroll up Quickfix List' })

-- Tab display settings
vim.opt.showtabline = 1 -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
vim.opt.tabline = ''    -- Use default tabline (empty string uses built-in)

-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end, { desc = 'Copy file full path'})
