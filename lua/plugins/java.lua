return {
  -- Asegura herramientas Java en Mason (LSP + debug + test + formato).
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "jdtls",
          "java-test",
          "java-debug-adapter",
          "google-java-format",
          "prettierd",
          "stylua",
          "ruff",
        },
      })
    end,
  },
  -- Debug: nvim-dap + UI (nvim-java lo usa para :JavaTest --debug, etc.)
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug: continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: repl" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: terminate" },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dapui = require("dapui")
      dapui.setup()
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  -- Formato multi-lenguaje (conform.nvim, format on save).
  -- prettierd/stylua/ruff los instala mason-tool-installer; si un
  -- binario falta, se usa el LSP como fallback (lsp_format).
  {
    "stevearc/conform.nvim",
    ft = {
      "java",
      "javascript", "javascriptreact", "typescript", "typescriptreact",
      "json", "jsonc", "css", "html",
      "python", "lua",
    },
    opts = {
      formatters_by_ft = {
        java = { "google-java-format", lsp_format = "fallback" },
        javascript = { "prettierd", lsp_format = "fallback" },
        javascriptreact = { "prettierd", lsp_format = "fallback" },
        typescript = { "prettierd", lsp_format = "fallback" },
        typescriptreact = { "prettierd", lsp_format = "fallback" },
        json = { "prettierd", lsp_format = "fallback" },
        jsonc = { "prettierd", lsp_format = "fallback" },
        css = { "prettierd", lsp_format = "fallback" },
        html = { "prettierd", lsp_format = "fallback" },
        python = { "ruff_format" },
        lua = { "stylua" },
      },
      format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
    },
  },
}
