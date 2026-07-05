local lazy = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
    {'catppuccin/nvim'},
    {'nvim-treesitter/nvim-treesitter'},
    {'neovim/nvim-lspconfig'},
    {'nvim-lua/lsp_extensions.nvim'},
    {'onsails/lspkind-nvim'},
    {'nvim-lua/lsp-status.nvim'},
    {'windwp/nvim-autopairs'},
    {"hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/vim-vsnip",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-nvim-lua",
          "hrsh7th/cmp-path"
        }
    },
    {'airblade/vim-gitgutter'},
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
        { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
      },
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>ff", "<cmd>Telescope file_browser path=%:p:h select_buffer=true auto_depth=true<cr>", desc = "File browser" },
      },
    },
    {
      'stevearc/oil.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }, -- optional, for icons
      opts = {
        view_options = { show_hidden = true },
        keymaps = {
          ["l"] = "actions.select",
          ["h"] = "actions.parent",
        },
      },
      keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      },
    },
    {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    }
})

