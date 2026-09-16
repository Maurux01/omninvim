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

      dashboard.section.header.val = {
        "██████╗ ███╗   ███╗███╗   ██╗██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "██╔═══██╗████╗ ████║████╗  ██║██║████╗  ██║██║   ██║██║████╗ ████║",
        "██║   ██║██╔████╔██║██╔██╗ ██║██║██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "██║   ██║██║╚██╔╝██║██║╚██╗██║██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "╚██████╔╝██║ ╚═╝ ██║██║ ╚████║██║██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "",
        "welocome " .. username,
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "Buscar archivos", "<cmd>Telescope find_files<CR>"),
        dashboard.button("r", "Archivos recientes", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("e", "Nuevo archivo", "<cmd>ene<CR><cmd>startinsert<CR>"),
        dashboard.button("o", "Explorador", "<cmd>Oil<CR>"),
        dashboard.button("l", "Plugins", "<cmd>Lazy<CR>"),
        dashboard.button("q", "Salir", "<cmd>qa<CR>"),
      }
      dashboard.section.header.opts.hl = "Title"
      dashboard.opts.opts.noautocmd = true
      require("alpha").setup(dashboard.opts)
    end,
  },
}
