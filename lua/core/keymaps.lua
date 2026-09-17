vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<C-h>", "<cmd>NavigatorLeft<CR>", { desc = "Window Left" })
vim.keymap.set("n", "<C-l>", "<cmd>NavigatorRight<CR>", { desc = "Window Right" })
vim.keymap.set("n", "<C-j>", "<cmd>NavigatorDown<CR>", { desc = "Window Down" })
vim.keymap.set("n", "<C-k>", "<cmd>NavigatorUp<CR>", { desc = "Window Up" })

-- Terminal: <Esc> sale a Normal, <C-hjkl> navega ventanas.
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal Normal Mode" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><cmd>NavigatorLeft<CR>]], { desc = "Window Left" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><cmd>NavigatorRight<CR>]], { desc = "Window Right" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><cmd>NavigatorDown<CR>]], { desc = "Window Down" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><cmd>NavigatorUp<CR>]], { desc = "Window Up" })

vim.keymap.set("n", "<leader>a", function() require("harpoon"):list():add() end, { desc = "Harpoon Add" })
vim.keymap.set("n", "<leader>h", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, { desc = "Harpoon Menu" })
vim.keymap.set("n", "<leader>H", function() require("harpoon"):list():clear() end, { desc = "Harpoon Clear All" })
vim.keymap.set("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon 4" })

vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash Jump" })
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Zen Mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save" })

vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bd", function()
  -- Cierre inteligente: NvimTree no cuenta como buffer.
  -- Si es el último archivo real, cierra el tree también para no
  -- dejar el tree huérfano (evita tener que hacer `:q!`).
  local function real_bufs()
    local t = {}
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted then
        local ft = vim.bo[b].filetype
        if ft ~= "NvimTree" and ft ~= "alpha" and ft ~= "dashboard" and ft ~= "oil" then
          t[#t + 1] = b
        end
      end
    end
    return t
  end
  if #real_bufs() <= 1 then
    pcall(function() require("nvim-tree.api").tree.close() end)
    vim.cmd("bdelete!")
    -- Si queda dashboard/alpha úsalo, si no sal de Neovim.
    if #vim.fn.getbufinfo({ buflisted = 1 }) == 0 then
      if not pcall(vim.cmd, "Alpha") then
        vim.cmd("quitall!")
      end
    end
  else
    vim.cmd("bdelete!")
  end
end, { desc = "Close Buffer" })
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Ultimo Buffer" })

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
    { name = "Dracula",           cmd = "colorscheme dracula" },
    { name = "Cyberdream",        cmd = "colorscheme cyberdream" },
    { name = "Eldritch",          cmd = "colorscheme eldritch" },
    { name = "Oxocarbon",         cmd = "colorscheme oxocarbon" },
    { name = "Moonfly",           cmd = "colorscheme moonfly" },
    { name = "Sonokai",           cmd = "colorscheme sonokai" },
    { name = "Code Dark",         cmd = "colorscheme codedark" },
    { name = "VSCode",            cmd = "colorscheme vscode" },
    { name = "GitHub Dark",       cmd = "colorscheme github_dark" },
    { name = "Nightfox",          cmd = "colorscheme nightfox" },
    { name = "Material Darker",   cmd = "colorscheme material" },
    { name = "Nordic",            cmd = "colorscheme nordic" },
    { name = "Melange",           cmd = "colorscheme melange" },
    { name = "Tokyo Dark",        cmd = "colorscheme tokyodark" },
    { name = "Ayu Dark",          cmd = "colorscheme ayu" },
    { name = "OneNord",           cmd = "colorscheme onenord" },
    { name = "Vesper",            cmd = "colorscheme vesper" },
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
    attach_mappings = function(prompt_bufnr)
      require("telescope.actions").select_default:replace(function()
        local selection = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        if selection then
          vim.cmd(selection.value.cmd)
        end
      end)
      return true
    end,
  }):find()
end, { desc = "Change Theme" })
