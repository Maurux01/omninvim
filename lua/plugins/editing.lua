return {
  -- Cierre automatico de {} [] () "" '' ``
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- usa treesitter para no cerrar dentro de strings, etc.
        fast_wrap = { map = "<M-e>" }, -- Alt+e envuelve la palabra con el par
      })
    end,
  },
  -- Cierre automatico de tags <> </> en html, jsx, tsx, vue, svelte, etc.
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "xml", "php" },
    opts = {},
  },
}
