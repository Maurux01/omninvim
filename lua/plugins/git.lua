return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("n", "]h", gs.next_hunk, "Git: siguiente hunk")
          map("n", "[h", gs.prev_hunk, "Git: hunk anterior")
          map("n", "<leader>gs", gs.stage_hunk, "Git: stage hunk")
          map("n", "<leader>gr", gs.reset_hunk, "Git: reset hunk")
          map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git: stage hunk")
          map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git: reset hunk")
          map("n", "<leader>gS", gs.stage_buffer, "Git: stage buffer")
          map("n", "<leader>gR", gs.reset_buffer, "Git: reset buffer")
          map("n", "<leader>gp", gs.preview_hunk, "Git: preview hunk")
          map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Git: blame línea")
          map("n", "<leader>gd", gs.diffthis, "Git: diff hunk")
        end,
      })
    end,
  },
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
