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
    dependencies = { "rafamadriz/friendly-snippets" },
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

      -- gd/gD no son defaults de Neovim: se definen al adjuntar el LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("SimplevimLspKeys", { clear = true }),
        callback = function(event)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Go to Definition" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "Go to Declaration" })
        end,
      })

      vim.lsp.config("vtsls", { capabilities = capabilities })
      vim.lsp.config("tailwindcss", { capabilities = capabilities })
      vim.lsp.config("html", {
        capabilities = capabilities,
        filetypes = { "html", "templ" },
        settings = {
          html = { format = { enable = true } },
        },
        init_options = {
          provideFormatter = true,
          embeddedLanguages = { css = true, javascript = true },
          configurationSection = { "html", "css", "javascript" },
        },
      })
      -- Emmet: expansiones tipo `div.container>ul>li*3` + sugerencias
      -- en html, css, jsx, tsx, vue, svelte, php, etc.
      vim.lsp.config("emmet_language_server", {
        capabilities = capabilities,
        filetypes = {
          "html", "css", "scss", "sass", "less",
          "javascript", "javascriptreact", "typescript", "typescriptreact",
          "vue", "svelte", "php", "eruby", "templ",
        },
      })
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
        ensure_installed = { "vtsls", "tailwindcss", "html", "cssls", "pyright", "lua_ls", "bashls", "emmet_language_server" },
        automatic_enable = false,
      })

      vim.lsp.enable({
        "vtsls",
        "tailwindcss",
        "html",
        "emmet_language_server",
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
