return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- The legacy configs module was removed on main (Neovim 0.12+).
    branch = vim.fn.has("nvim-0.12") == 1 and "main" or "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("core.treesitter").setup()
    end,
  },
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "enter" },
      appearance = { nerd_font_variant = "mono" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("vtsls", { capabilities = capabilities })
      vim.lsp.config("tailwindcss", { capabilities = capabilities })
      vim.lsp.config("html", { capabilities = capabilities })
      vim.lsp.config("cssls", { capabilities = capabilities })
      vim.lsp.config("bashls", { capabilities = capabilities })
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })
      

      require("mason-lspconfig").setup({
        ensure_installed = { "vtsls", "tailwindcss", "html", "cssls", "pyright", "lua_ls", "bashls" },
        automatic_enable = false,
      })

      vim.lsp.enable({
        "vtsls",
        "tailwindcss",
        "html",
        "cssls",
        "pyright",
        "lua_ls",
        "bashls",
      })
    end,
  },
  {
    "nvim-java/nvim-java",
    ft = "java",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("java").setup()
      vim.lsp.config("jdtls", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      vim.lsp.enable("jdtls")
    end,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({ render = "background" })
    end,
  },
}
