# simplevim

A clean, fast fullstack Neovim setup built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) ideas and managed with **Lazy.nvim**.

## Features

- **File explorer on the right**: `nvim-tree` sidebar (`<leader>e` to toggle, `<C-n>` to focus)
- **Floating command line**: `noice.nvim` popup (`:` floats centered, `lualine` stays glued to the bottom)
- **Real line numbers**: absolute numbers, no relative mode
- **No `~` filler**: clean end-of-buffer via `fillchars`
- **8 themes on demand**: Catppuccin Frappe (default), Rose Pine Moon, Tokyo Night, Gruvbox Material, Everforest, Nord, OneDark, Kanagawa — switch with `<leader>th`
- **Completion**: `blink.cmp` with LSP, path, snippets and buffer sources
- **LSP via Mason**: `vtsls`, `tailwindcss`, `html`, `cssls`, `pyright`, `lua_ls`, `jdtls` (Java) — no `sqls`
- **Treesitter**: syntax + indent for JS/TS, HTML, CSS, Python, Java, SQL, JSON, Lua
- **Workflow**: Telescope, Trouble, Flash, Harpoon, Oil, Yanky (history), Genghis, Zen Mode, WakaTime
- **Git**: `gitsigns` + `freeze-code.nvim` screenshots (`<leader>sc`, needs the `freeze` CLI)
- **Statusline**: `lualine` + `bufferline` + `nvim-notify`

## Structure

```
init.lua                 Lazy bootstrap + core modules
lua/core/options.lua     Numbers, fillchars, cmdheight, indent, clipboard
lua/core/keymaps.lua     Leader, navigation, Harpoon, Flash, themes
lua/core/treesitter.lua  Parser list + setup (0.11 / 0.12 API)
lua/plugins/dashboard.lua  alpha-nvim start screen (centered OMNI banner)
lua/plugins/ui.lua       Themes, lualine, bufferline, notify, noice, zen
lua/plugins/lsp.lua      Treesitter, Mason, blink.cmp, lspconfig, Java
lua/plugins/workflow.lua Telescope, Trouble, Flash, Harpoon, Oil, Yanky
lua/plugins/git.lua      gitsigns, freeze-code
lua/plugins/explorer.lua nvim-tree (right side)
script.sh                Smart installer (Arch / Debian / Fedora)
```

## Installation

```bash
git clone https://github.com/Maurux01/simplevim.git
cd simplevim
./script.sh
```

The script only installs what's missing (Neovim 0.11.5+, `rg`, `fd`, node, Mason servers, Treesitter parsers), backs up your old `~/.config/nvim`, and copies this config over. Re-running it just re-syncs.

> Optional: the `freeze` CLI (for `:Freeze` screenshots) is **not** installed by the script — it only warns. Get it from [charmbracelet/freeze](https://github.com/charmbracelet/freeze).

Open `nvim`, then `:Lazy` / `:Mason` to verify.

## Keymaps

| Keys | Action |
|------|--------|
| `<leader>e` / `<C-n>` | Toggle / focus file tree |
| `<C-h/j/k/l>` | Move between splits (Navigator) |
| `<leader>a`, `<leader>1-4` | Harpoon add / jump |
| `s` | Flash jump |
| `<leader>z` | Zen Mode |
| `<leader>th` | Theme picker |
| `<leader>fn/fr/fm/fD` | New / rename / move / trash file (Genghis) |
| `<leader>sc` | Screenshot code (Freeze) |
| `<C-s>` | Save |
| `<C-p>` / `<C-n>` | Cycle yank history |
| `y` / `p` / `P` | Yank / paste (Yanky) |

Leader is `<Space>`.

## LSP servers

| Server | Language |
|--------|----------|
| `vtsls` | TypeScript / JavaScript |
| `tailwindcss` | Tailwind CSS |
| `html` | HTML |
| `cssls` | CSS / SCSS / Less |
| `pyright` | Python |
| `lua_ls` | Lua |
| `jdtls` | Java (via nvim-java, filetype only) |

## Requirements

- Neovim **0.11.5+**
- `git`, `rg`, `fd`, `node`, `npm`, `python3`
- `tree-sitter` CLI ≥ 0.26.1 (the script installs it if missing)
