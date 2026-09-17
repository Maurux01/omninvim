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
  -- Formato Java (google-java-format, fallback a jdtls).
  {
    "stevearc/conform.nvim",
    ft = { "java" },
    opts = {
      formatters_by_ft = {
        java = { "google-java-format", lsp_format = "fallback" },
      },
      format_on_save = { timeout_ms = 2000, lsp_format = "fallback" },
    },
  },
}
