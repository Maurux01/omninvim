return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "brianhuster/live-preview.nvim",
    cmd = { "LivePreview" },
    keys = {
      { "<leader>pv", "<cmd>LivePreview<CR>", desc = "Live Preview" },
    },
    opts = {},
  },
}
