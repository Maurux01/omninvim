local M = {}

M.parsers = {
  "javascript", "typescript", "tsx", "html", "css",
  "python", "java", "sql", "json", "lua",
}

function M.setup()
  if vim.fn.has("nvim-0.12") == 0 then
    require("nvim-treesitter.configs").setup({
      ensure_installed = vim.env.SIMPLEVIM_INSTALL == "1" and {} or M.parsers,
      highlight = { enable = true },
      indent = { enable = true },
    })
    return
  end

  local ts = require("nvim-treesitter")
  ts.setup()
  if vim.env.SIMPLEVIM_INSTALL ~= "1" then
    ts.install(M.parsers)
  end
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("SimplevimTreesitter", { clear = true }),
    callback = function(event)
      local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
      if lang and vim.list_contains(M.parsers, lang) then
        -- A parser may still be downloading on the first launch.
        if pcall(vim.treesitter.start, event.buf, lang) then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end
    end,
  })
end

function M.install()
  if vim.fn.has("nvim-0.12") == 1 then
    require("nvim-treesitter").install(M.parsers):wait(300000)
  else
    vim.cmd("TSInstallSync " .. table.concat(M.parsers, " "))
  end
  for _, lang in ipairs(M.parsers) do
    assert(vim.treesitter.language.add(lang), "No se pudo instalar el parser: " .. lang)
  end
end

return M
