require('statusline')

-- Neovim will generate gb's of logs for some reason when logging is set to `WARN`
vim.lsp.log.set_level(vim.log.levels.ERROR)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local function nnoremap(key, com)
        vim.keymap.set('n', key, com, { buffer = ev.buf })
    end

    nnoremap("~",  vim.diagnostic.open_float)
    nnoremap("<leader>d", vim.lsp.buf.definition)
    nnoremap("<leader>i", vim.lsp.buf.implementation)
    nnoremap("<leader>t", vim.lsp.buf.type_definition)
    nnoremap("<leader>s", vim.lsp.buf.document_symbol)
    nnoremap("<leader>e", vim.lsp.buf.declaration)
    nnoremap("<leader>j", vim.lsp.buf.code_action)
    nnoremap("<leader>f", function() vim.cmd("Format") end)
    nnoremap("<leader>r", vim.lsp.buf.references)
  end,
})

-- Icons for LSP window
local lspkind = require('lspkind')
lspkind.init {
  mode = 'symbol_text',
  preset = 'codicons',
  symbol_map = {
    Constructor = "",
    Variable = "",
    Interface = "",
    Module = "",
    Enum = "",
    Snippet = "",
    EnumMember = "",
    Event = "",
    TypeParameter = ""
  },
}

-- Lsp front-end helper functions
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')
cmp.setup {
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      return vim_item
    end
  },
  mapping = {
      ['<Tab>'] = cmp.mapping.confirm({ select = true }),
      ["<C-n>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-p>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end, { "i", "s" }),
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
  }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Defaults applied to ALL servers (merged into every config).
-- Replaces the on_attach/capabilities args previously passed to each setup{}.
vim.lsp.config('*', {
  capabilities = capabilities,
})

-- Per-server overrides (merged with nvim-lspconfig's configs from its lsp/ dir)
vim.lsp.config('hls', {
  cmd = { vim.fn.expand("~/.ghcup/bin/haskell-language-server-wrapper"), "--lsp" },
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

vim.lsp.config('rust_analyzer', {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        loadOutDirsFromCheck = true
      },
      checkOnSave = true,
      check = {
        allTargets = false,
      },
      rustfmt = {
        extraArgs = { "+nightly" },
      },
      diagnostics = {
        disabled = {"inactive-code", "unresolved-proc-macro", "mismatched-arg-count"},
        enableExperimental = true
      }
    }
  }
})

local lspservers = {
    "cssls",
    "html",
    "jsonls",
    "ts_ls",
}

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = lspservers,
})

local binaries = {
    {"pyright", "`pip install pyright`"},
    {"clangd", "install llvm or `npm i --location=global @clangd/install`"},
}

for _, triplet in ipairs(binaries) do
    local binary, command = triplet[1], triplet[2]

    if vim.fn.executable(binary) == 0 then
        vim.cmd(":MasonInstall " .. binary)
        print(binary .. " not found")
        print(command)
        print(" ")
    end
end

vim.lsp.enable({ "pyright", "clangd", "hls", "rust_analyzer" })

require("nvim-autopairs").setup {
  check_ts = true,
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

-- Visual diagnostics
-- (replaces the deprecated vim.lsp.with / publishDiagnostics handler override)
vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  update_in_insert = true,
  underline = true,
})

-- formatter
vim.api.nvim_create_user_command("Format",
    function(...)
        if vim.bo.filetype == "python" then
            if vim.fn.executable("black") == 1 then
                fname = vim.api.nvim_buf_get_name(0)
                vim.cmd("!black %")
            end
        elseif vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
            vim.cmd('%!clang-format -style="{IndentWidth: 4}"')
        else
            vim.lsp.buf.format({ async = true })
        end
    end,
    {}
)
