return {
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",                             config = function() require(
    "nvim-treesitter.configs").setup({ ensure_installed = { "javascript", "typescript", "tsx", "html", "css", "python", "java", "sql", "json", "lua" }, highlight = { enable = true }, indent = { enable = true } }) end },
  { "mason-org/mason.nvim",            config = function() require("mason").setup() end },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      for _, lsp in ipairs({ "vtsls", "tailwindcss", "html", "cssls", "pyright", "lua_ls" }) do
        lspconfig[lsp].setup({ capabilities = capabilities })
      end
    end
  },
  { "nvim-java/nvim-java",                dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },                       config = function()
    require("java").setup() end },
  { "saghen/blink.cmp",                   version = "*",                                                                            opts = { keymap = { preset = "enter" }, appearance = { nerd_font_variant = "mono" }, sources = { default = { "lsp", "path", "snippets", "buffer" } } } },
  { "brenoprata10/nvim-highlight-colors", config = function() require("nvim-highlight-colors").setup({ render =
    "background" }) end },
}
