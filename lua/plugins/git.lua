return {
  { "lewis6991/gitsigns.nvim",         config = function() require("gitsigns").setup() end },
  -- Screenshots sin depender del binario externo `freeze`:
  -- usa la API de ray.so (solo necesita curl + internet).
  {
    "TobinPalmer/rayso.nvim",
    cmd = { "Rayso" },
    keys = {
      { "<leader>sc", "<cmd>Rayso<CR>", desc = "Screenshot (ray.so)", mode = "v" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
