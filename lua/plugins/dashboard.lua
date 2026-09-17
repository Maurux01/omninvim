return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      local username = vim.env.USER or vim.env.USERNAME
      if not username or username == "" then
        local ok, passwd = pcall(vim.uv.os_get_passwd)
        username = ok and passwd and passwd.username or "usuario"
      end

      local art = {
        "██████╗ ███╗   ███╗███╗   ██╗██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "██╔═══██╗████╗ ████║████╗  ██║██║████╗  ██║██║   ██║██║████╗ ████║",
        "██║   ██║██╔████╔██║██╔██╗ ██║██║██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "██║   ██║██║╚██╔╝██║██║╚██╗██║██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "╚██████╔╝██║ ╚═╝ ██║██║ ╚████║██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "",
        "welcome " .. username,
      }
      -- Centra cada línea al ancho máximo para que el bloque quede alineado
      local max_w = 0
      for _, line in ipairs(art) do
        max_w = math.max(max_w, vim.fn.strdisplaywidth(line))
      end
      for i, line in ipairs(art) do
        local pad = math.floor((max_w - vim.fn.strdisplaywidth(line)) / 2)
        art[i] = string.rep(" ", pad) .. line
      end
      dashboard.section.header.val = art
      dashboard.section.buttons.val = {
        dashboard.button("f", "Buscar archivos", "<cmd>Telescope find_files<CR>"),
        dashboard.button("r", "Archivos recientes", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("n", "Nuevo archivo", "<cmd>ene<CR><cmd>startinsert<CR>"),
        dashboard.button("e", "Explorador", "<cmd>Oil<CR>"),
        dashboard.button("l", "Plugins", "<cmd>Lazy<CR>"),
        dashboard.button("q", "Salir", "<cmd>qa<CR>"),
      }
      dashboard.section.header.opts.hl = "Title"
      dashboard.section.header.opts.position = "center"
      dashboard.opts.opts.noautocmd = true
      require("alpha").setup(dashboard.opts)
    end,
  },
}
