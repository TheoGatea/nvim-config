--[[ keys.lua ]]

local ops = { noremap = true, silent = true }
local function inoremap(key, com) vim.keymap.set('i', key, com, ops) end
local function nnoremap(key, com) vim.keymap.set('n', key, com, ops) end
local function tnoremap(key, com) vim.keymap.set('t', key, com, ops) end

-- utility binds
nnoremap("fdklasjflksj", "<Esc>")
inoremap("jj", "<Esc>")
tnoremap("<C-t>", [[<C-\><C-n>]])

-- split binds
nnoremap("<leader>vs", "<cmd>vs<cr>")
nnoremap("<leader>hs", "<cmd>split<cr>")
nnoremap("<leader>t", "<cmd>tabnew<cr>")

-- buffer manipulation shortcuts
nnoremap("<leader>q", "<cmd>q<cr>")
nnoremap("<leader>w", "<cmd>w<cr>")
nnoremap("<leader>aq", "<cmd>qa<cr>")
