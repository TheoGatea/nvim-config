--[[opts.lua]]

--[[Context]]
vim.opt.colorcolumn = '80'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"

--[[Filetypes]]
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

--[[Theme]]
vim.opt.syntax = "ON"
vim.opt.termguicolors = true
vim.cmd.colorscheme('catppuccin')

--[[Search]]
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- [[ Whitespace ]]
vim.opt.expandtab = true
vim.opt.shiftwidth = 4 
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.breakindent = true

-- [[ Splits ]]
vim.opt.splitright = true
vim.opt.splitbelow = true
