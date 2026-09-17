# omninvim

A fullstack Neovim setup built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) ideas and managed with **Lazy.nvim**.

## Features

- **File explorer on the right**: `nvim-tree` sidebar (`<leader>e` to toggle, `<leader>E` to focus)
- **Floating command line**: `noice.nvim` popup (`:` floats centered, `lualine` stays glued to the bottom)
- **Real line numbers**: absolute numbers, no relative mode
- **No `~` filler**: clean end-of-buffer via `fillchars`
- **25 themes on demand**: Catppuccin Frappe (default), Rose Pine Moon, Tokyo Night, Gruvbox Material, Everforest, Nord, OneDark, Kanagawa, Dracula, Cyberdream, Eldritch, Oxocarbon, Moonfly, Sonokai, Code Dark, VSCode, GitHub Dark, Nightfox, Material Darker, Nordic, Melange, Tokyo Dark, Ayu Dark, OneNord, Vesper — all dark, switch with `<leader>th`
- **Completion**: `blink.cmp` with LSP, path, snippets and buffer sources
- **LSP via Mason**: `vtsls`, `tailwindcss`, `html`, `cssls`, `pyright`, `lua_ls`, `bashls`, `jdtls` (Java) — no `sqls`
- **Treesitter**: syntax + indent for JS/TS, HTML, CSS, Python, Java, SQL, JSON, Lua, Bash
- **Workflow**: Telescope, Trouble, Flash, Harpoon, Oil, Yanky (history), Genghis, Zen Mode, WakaTime
- **Autopairs**: `nvim-autopairs` auto-closes `{} [] () "" '' ``` + `nvim-ts-autotag` auto-closes tags `<> </>` in HTML/JSX/TSX/Vue
- **Git**: `gitsigns` (hunks with `]h`/`[h` and `<leader>g*`, see [Git hunks](#git-hunks)) + `rayso.nvim` for screenshots (`<leader>sc` in visual mode, no external binary)
- **Statusline**: per-split `lualine` (each split gets its own, inactive ones dimmed, none in the tree) + orange active-window border (`colorful-winsep`) + `bufferline` + `nvim-notify`
- **Format on save**: `conform.nvim` — `prettierd` (JS/TS/JSX/TSX/JSON/CSS/HTML), `ruff` (Python), `stylua` (Lua), `google-java-format` (Java); with LSP fallback (see [Format](#format))
- **In-buffer Markdown**: `render-markdown.nvim` renders it nicely, no browser needed
- **Live server**: `live-preview.nvim` (`<leader>pv`) serves HTML with live reload (see [Live Server](#live-server))
- **Terminal**: `<Esc>` exits to Normal mode, `<C-h/j/k/l>` moves between splits with `Navigator.nvim`

## Structure

```
init.lua                 Lazy bootstrap + core modules
lua/core/options.lua     Numbers, fillchars, cmdheight, indent, clipboard
lua/core/keymaps.lua     Leader, navigation, Harpoon, Flash, themes, terminal
lua/core/treesitter.lua  Parser list + setup (0.11 / 0.12 API)
lua/plugins/dashboard.lua  alpha-nvim start screen (centered OMNI banner)
lua/plugins/ui.lua       Themes, lualine, bufferline, notify, noice, zen
lua/plugins/lsp.lua      Treesitter, Mason, blink.cmp, lspconfig, Java
lua/plugins/java.lua     Java: mason-tool-installer (jdtls/test/debug + prettierd/stylua/ruff), nvim-dap + UI, conform (format on save multi-lenguaje)
lua/plugins/workflow.lua Telescope, Trouble, Flash, Harpoon, Oil, Yanky
lua/plugins/git.lua      gitsigns (hunk keymaps `<leader>g*`, `]h`/`[h`), rayso.nvim (screenshots without CLI freeze)
lua/plugins/explorer.lua nvim-tree (right side, follows the active buffer)
lua/plugins/editing.lua  nvim-autopairs ({} [] () "") + nvim-ts-autotag (<>)
lua/plugins/preview.lua  render-markdown, live-preview
script.sh                Smart installer (Arch / Debian / Fedora)
```

## Installation

```bash
git clone https://github.com/Maurux01/omninvim.git
cd omninvim
./script.sh
```

The script only installs what's missing (Neovim 0.11.5+, `rg`, `fd`, node, Mason servers, Treesitter parsers), backs up your old `~/.config/nvim`, and copies this config over. Re-running it just re-syncs.

Open `nvim`, then `:Lazy` / `:Mason` to verify.

## Keymaps

Leader is `<Space>`.

### General

| Keys | Action |
|------|--------|
| `<C-s>` | Save file |
| `<Esc>` | Clear search highlight |
| `<leader>th` | Theme picker (25 themes) |
| `<leader>z` | Zen Mode |
| `<leader>nd` | Close/dismiss all notifications |

> If a notification does not go away with `<leader>nd`, close it with `:NoiceDismiss`.

### Explorer (nvim-tree on the right + Oil as a buffer)

| Keys | Action |
|------|--------|
| `<leader>e` | Toggle tree |
| `<leader>E` | Focus tree |
| `-` / `<leader>o` | Oil: open the directory **as a buffer** (without opening/closing the tree) |

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

### Buffers (move between open files)

| Keys | Action |
|------|--------|
| `<S-h>` / `<S-l>` | Previous / next buffer (cycle with `bufferline`) |
| `<leader>bd` | Close current buffer (forced with `!`, no save prompt) |
| `:b <name><Tab>` | Go to a buffer by name (autocompletes) |

> Open buffers show as tabs on top (`bufferline`). Files pinned with Harpoon (`<leader>a`) jump directly with `<leader>1` – `<leader>4`.

### Splits

Create them with native keys, move between them with `Navigator.nvim`:

| Keys | Action |
|------|--------|
| `<C-w>v` / `<C-w>s` | Vertical / horizontal split |
| `<C-w>c` / `<C-w>o` | Close split / keep only current (forced with `!`, no save prompt) |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move to left / down / up / right split |

### Terminal (`:terminal`)

| Keys | Action |
|------|--------|
| `<Esc>` | Exit Terminal-Insert to Normal mode (`<C-\><C-n>`) |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move to left / down / up / right split via `Navigator.nvim` |
| `i` / `a` | Go back to terminal input |

Flow: open with `:terminal`, press `<Esc>` to move with `hjkl` / `Ctrl-w`, press `i` to type again.

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
| `<leader>H` | Unpin all files |
| `<leader>1` – `<leader>4` | Jump to pinned file 1–4 |

To **unpin a single file**: `<leader>h`, delete its line with `dd` and save with `:w` (it is not applied without `:w`). Note: `<leader>h` only opens/closes the menu, closing it that way does **not** save.

Pinned slots show in the statusline as `󰐃 1○ 2● …` — `●` marks the slot of the current buffer.

### Motion & files

| Keys | Action |
|------|--------|
| `s` | Flash jump |
| `<leader>fn` | New file (Genghis) |
| `<leader>fr` | Rename file |
| `<leader>fm` | Move file |
| `<leader>fD` | Trash file |

### Git hunks

| Keys | Action |
|------|--------|
| `]h` / `[h` | Next / previous hunk |
| `<leader>gs` / `<leader>gr` | Stage / reset hunk (works in visual with a selection) |
| `<leader>gS` / `<leader>gR` | Stage / reset whole buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gd` | Diff hunk |

### Format

`conform.nvim` formats on save (`:w`): `prettierd` for JS/TS/JSX/TSX/JSON/CSS/HTML, `ruff` for Python, `stylua` for Lua, `google-java-format` for Java. Mason installs the binaries by itself; if one is missing the LSP is used as fallback. Check status with `:ConformInfo`.

### Screenshots (no `freeze`)

| Keys | Action |
|------|--------|
| `<leader>sc` | Screenshot of the visual selection with ray.so (`:Rayso`, needs internet) |
| `<leader>pv` | Live preview of the current HTML |
| `<leader>pV` | Close the live preview |

### Autopairs

`nvim-autopairs` + `nvim-ts-autotag` are enabled: type `{`, `[`, `(`, `"` or `<div>` and it closes automatically. `Alt+e` (`<M-e>`) wraps the current word with the pair.

### Autocompletion (how to pick a suggestion)

While typing, the `blink.cmp` menu shows up (LSP + snippets + buffer + paths):

| Keys | Action |
|------|--------|
| `<Tab>` / `<S-Tab>` | Next / previous suggestion (if no menu, jump to next / previous snippet placeholder) |
| `<C-n>` / `<C-p>` (or `<Down>` / `<Up>`) | Move to next / previous suggestion |
| `<CR>` (Enter) | Accept the highlighted suggestion |
| `<C-e>` | Close the menu without accepting |
| `<C-Space>` | Force the menu / show docs |
| `<C-b>` / `<C-f>` | Scroll up / down in docs |
| `<C-k>` | Show/hide function signature |

> `<CR>` accepts the highlighted item; if nothing is highlighted it inserts a normal Enter. `enter` preset with `Tab`/`S-Tab` remapped to `select_next`/`select_prev` (with fallback to `snippet_forward`/`snippet_backward`, see `keymap` in `lua/plugins/lsp.lua`).

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

## Live Server

1. Open an `.html` file in nvim.
2. Press `<leader>pv` (or run `:LivePreview`). It opens `http://localhost:5500` in your browser.
3. Edit and save (`<C-s>`): the browser reloads automatically.
4. To stop it: `<leader>pV` (or `:LivePreviewClose`).

> The port is configured in `lua/plugins/preview.lua` (`opts.port = 5500`).

## Explorer without opening/closing the tree

The side tree no longer steals focus: when you open a file with `<CR>` the cursor moves to the buffer and the tree follows the selection (`update_focused_file`). To avoid depending on the tree, use **Oil as a buffer**:

1. Press `-` (or `<leader>o`): the current directory opens as a normal buffer.
2. Navigate with `j/k`, enter with `<CR>`, go up with `-`, create with `%`, rename with `R`, delete with `D`.
3. Save with `:w` to apply changes to disk and go back with `<C-o>` or switch buffers with `<S-h>` / `<S-l>`.

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
| 9 | Dracula | Classic dark |
| 10 | Cyberdream | Neon dark, transparent |
| 11 | Eldritch | Neon dark |
| 12 | Oxocarbon | Near-black (IBM Carbon) |
| 13 | Moonfly | Dark, high contrast |
| 14 | Sonokai | Dark, monochrome-friendly |
| 15 | Code Dark | VS Code dark |
| 16 | VSCode | VS Code dark+ |
| 17 | GitHub Dark | GitHub dark |
| 18 | Nightfox | Dark blue |
| 19 | Material Darker | Material darker |
| 20 | Nordic | Nord-based dark |
| 21 | Melange | Warm dark |
| 22 | Tokyo Dark | Dark navy |
| 23 | Ayu Dark | Dark gray-yellow |
| 24 | OneNord | Nord-based dark |
| 25 | Vesper | Deep dark teal |

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
| `java-test` / `java-debug-adapter` | Java test + debug (via nvim-dap, `<leader>db/dc/do/di`) |
| `google-java-format` | Java format (via conform.nvim, format on save) |
| `prettierd` | JS/TS/JSX/TSX/JSON/CSS/HTML format (via conform.nvim, format on save, LSP fallback) |
| `ruff` | Python format via `ruff_format` (via conform.nvim, format on save) |
| `stylua` | Lua format (via conform.nvim, format on save) |

## Requirements

- Neovim **0.11.5+**
- `git`, `rg`, `fd`, `node`, `npm`, `python3`
- `tree-sitter` CLI ≥ 0.26.1 (the script installs it if missing)

## Made by

[maurux01](https://github.com/Maurux01)
