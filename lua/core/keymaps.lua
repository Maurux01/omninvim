vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<C-h>", "<cmd>NavigatorLeft<CR>", { desc = "Window Left" })
vim.keymap.set("n", "<C-l>", "<cmd>NavigatorRight<CR>", { desc = "Window Right" })
vim.keymap.set("n", "<C-j>", "<cmd>NavigatorDown<CR>", { desc = "Window Down" })
vim.keymap.set("n", "<C-k>", "<cmd>NavigatorUp<CR>", { desc = "Window Up" })

vim.keymap.set("n", "<leader>a", function() require("harpoon"):list():add() end, { desc = "Harpoon Add" })
vim.keymap.set("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon 4" })

vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash Jump" })
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Zen Mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save" })

vim.keymap.set("n", "<leader>th", function()
  local themes = {
    { name = "Catppuccin Frappe", cmd = "colorscheme catppuccin" },
    { name = "Rose Pine Moon",    cmd = "colorscheme rose-pine" },
    { name = "Tokyo Night",       cmd = "colorscheme tokyonight" },
    { name = "Gruvbox Material",  cmd = "colorscheme gruvbox-material" },
    { name = "Everforest",        cmd = "colorscheme everforest" },
    { name = "Nord",              cmd = "colorscheme nord" },
    { name = "OneDark",           cmd = "colorscheme onedark" },
    { name = "Kanagawa Wave",     cmd = "colorscheme kanagawa" },
  }
  require("telescope.pickers").new({}, {
    prompt_title = "Select Theme",
    finder = require("telescope.finders").new_table({
      results = themes,
      entry_maker = function(entry)
        return { value = entry, display = entry.name, ordinal = entry.name }
      end,
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", function()
        local selection = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        vim.cmd(selection.value.cmd)
      end)
      return true
    end,
  }):find()
end, { desc = "Change Theme" })
