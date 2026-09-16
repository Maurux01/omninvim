return {
  { "lewis6991/gitsigns.nvim",         config = function() require("gitsigns").setup() end },
  {
    "AlejandroSuero/freeze-code.nvim",
    cmd = { "Freeze", "FreezeLine" },
    keys = {
      { "<leader>sc", "<cmd>Freeze<CR>", desc = "Freeze Code" },
    },
    opts = {},
  },
}
