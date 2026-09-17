return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "brianhuster/live-preview.nvim",
    cmd = { "LivePreview", "LivePreviewClose" },
    keys = {
      { "<leader>pv", "<cmd>LivePreview<CR>", desc = "Live Preview" },
      { "<leader>pV", "<cmd>LivePreviewClose<CR>", desc = "Cerrar Preview" },
    },
    opts = {
      port = 5500,
      browser = "default",
    },
  },
}
