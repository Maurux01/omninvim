# simplevim

A clean, fast fullstack Neovim setup built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) ideas and managed with **Lazy.nvim**.

## Features

- **File explorer on the right**: `nvim-tree` sidebar (`<leader>e` to toggle, `<leader>E` to focus)
- **Floating command line**: `noice.nvim` popup (`:` floats centered, `lualine` stays glued to the bottom)
- **Real line numbers**: absolute numbers, no relative mode
- **No `~` filler**: clean end-of-buffer via `fillchars`
- **8 themes on demand**: Catppuccin Frappe (default), Rose Pine Moon, Tokyo Night, Gruvbox Material, Everforest, Nord, OneDark, Kanagawa — switch with `<leader>th`
- **Completion**: `blink.cmp` with LSP, path, snippets and buffer sources
- **LSP via Mason**: `vtsls`, `tailwindcss`, `html`, `cssls`, `pyright`, `lua_ls`, `bashls`, `jdtls` (Java) — no `sqls`
- **Treesitter**: syntax + indent for JS/TS, HTML, CSS, Python, Java, SQL, JSON, Lua, Bash
- **Workflow**: Telescope, Trouble, Flash, Harpoon, Oil, Yanky (history), Genghis, Zen Mode, WakaTime
- **Git**: `gitsigns` + `freeze-code.nvim` screenshots (`<leader>sc`, requires the `freeze` CLI)
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

The script only installs what's missing (Neovim 0.11.5+, `rg`, `fd`, node, `freeze` CLI, Mason servers, Treesitter parsers), backs up your old `~/.config/nvim`, and copies this config over. Re-running it just re-syncs.

> `freeze` (required for `:Freeze` screenshots) is installed automatically from the official charmbracelet binary into `~/.local/bin` — it's not in the official Arch repos (AUR only). Override the version with `FREEZE_VERSION=x.y.z ./script.sh`.

Open `nvim`, then `:Lazy` / `:Mason` to verify.

## Keymaps

Leader is `<Space>`.

### General

| Keys | Action |
|------|--------|
| `<C-s>` | Save file |
| `<Esc>` | Clear search highlight |
| `<leader>th` | Theme picker (8 themes) |
| `<leader>z` | Zen Mode |

### Explorer (nvim-tree, right side)

| Keys | Action |
|------|--------|
| `<leader>e` | Toggle tree |
| `<leader>E` | Focus tree |

Inside the tree:

| Keys | Action |
|------|--------|
| `<CR>` / `o` | Open file / expand folder |
| `a` | Create file / folder |
| `d` | Delete |
| `r` | Rename |
| `x` / `c` / `p` | Cut / copy / paste |
| `R` | Refresh |
| `W` | Collapse all |
| `-` | Go up one directory |
| `q` | Close tree |
| `g?` | Show all tree mappings |

### Buffers

| Keys | Action |
|------|--------|
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bd` | Close buffer |

### Splits

| Keys | Action |
|------|--------|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move to left / down / up / right split |

### Yanky (yank history)

| Keys | Action |
|------|--------|
| `y` | Yank (saves to history) |
| `p` / `P` | Paste after / before |
| `<C-p>` / `<C-n>` | Cycle history forward / backward |

### Harpoon (pinned files)

| Keys | Action |
|------|--------|
| `<leader>a` | Pin current file |
| `<leader>h` | Visual menu with pinned files |
| `<leader>1` – `<leader>4` | Jump to pinned file 1–4 |

Pinned slots show in the statusline as `󰐃 1○ 2● …` — `●` marks the slot of the current buffer.

### Motion & files

| Keys | Action |
|------|--------|
| `s` | Flash jump |
| `<leader>fn` | New file (Genghis) |
| `<leader>fr` | Rename file |
| `<leader>fm` | Move file |
| `<leader>fD` | Trash file |

### Screenshots

| Keys | Action |
|------|--------|
| `<leader>sc` | Screenshot selection (`:Freeze`, needs the `freeze` CLI) |

### LSP (buffer with active server; `gd`/`gD` defined by this config, rest are Neovim 0.11+ defaults)

| Keys | Action |
|------|--------|
| `gd` / `gD` | Go to definition / declaration |
| `K` | Hover docs |
| `gri` | Go to implementation |
| `grr` | References |
| `grn` | Rename symbol |
| `gra` | Code action |
| `gO` | Document symbols |

## Themes

Press `<leader>th` to open the theme picker (Telescope):

| # | Theme | Variant |
|---|-------|---------|
| 1 | Catppuccin (default) | Frappe, transparent |
| 2 | Rose Pine | Moon |
| 3 | Tokyo Night | Night, transparent |
| 4 | Gruvbox Material | Soft background |
| 5 | Everforest | Soft background |
| 6 | Nord | Transparent |
| 7 | OneDark | Darker, transparent |
| 8 | Kanagawa | Wave, transparent |

Select with `<CR>`, cancel with `<Esc>`. The choice lasts for the session; to change the default, edit the `colorscheme` call in `lua/plugins/ui.lua`.

## LSP servers

| Server | Language |
|--------|----------|
| `vtsls` | TypeScript / JavaScript |
| `tailwindcss` | Tailwind CSS |
| `html` | HTML |
| `cssls` | CSS / SCSS / Less |
| `pyright` | Python |
| `lua_ls` | Lua |
| `bashls` | Bash / Shell |
| `jdtls` | Java (via nvim-java, filetype only) |

## Requirements

- Neovim **0.11.5+**
- `git`, `rg`, `fd`, `node`, `npm`, `python3`
- `tree-sitter` CLI ≥ 0.26.1 (the script installs it if missing)
