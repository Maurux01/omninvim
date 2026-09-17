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
- **Autopares**: `nvim-autopairs` cierra `{} [] () "" '' ``` automáticamente + `nvim-ts-autotag` cierra tags `<> </>` en HTML/JSX/TSX/Vue
- **Git**: `gitsigns` + `rayso.nvim` para screenshots (`<leader>sc` en modo visual, sin binario externo)
- **Statusline**: `lualine` + `bufferline` + `nvim-notify`
- **Markdown en el buffer**: `render-markdown.nvim` lo renderiza bonito, sin navegador
- **Live server**: `live-preview.nvim` (`<leader>pv`) sirve HTML con recarga en vivo (ver [Live Server](#live-server))

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
lua/plugins/git.lua      gitsigns, rayso.nvim (screenshots sin freeze CLI)
lua/plugins/explorer.lua nvim-tree (right side, sigue el buffer activo)
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
| `<leader>th` | Theme picker (8 themes) |
| `<leader>z` | Zen Mode |

### Explorer (nvim-tree a la derecha + Oil como buffer)

| Keys | Action |
|------|--------|
| `<leader>e` | Toggle tree |
| `<leader>E` | Focus tree |
| `-` / `<leader>o` | Oil: abre el directorio **como un buffer** (sin abrir/cerrar el tree) |

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

### Buffers (moverse entre archivos abiertos)

| Keys | Action |
|------|--------|
| `<S-h>` / `<S-l>` | Buffer anterior / siguiente (ciclo con `bufferline`) |
| `<leader>bd` | Cerrar buffer actual |
| `<leader><leader>` (doble espacio) | Saltar al último buffer visitado (alternar entre 2 archivos) |
| `:b <nombre><Tab>` | Ir a un buffer por nombre (autocompleta) |

> Los buffers abiertos se ven como pestañas arriba (`bufferline`). Los archivos fijados con Harpoon (`<leader>a`) saltan directo con `<leader>1` – `<leader>4`.

### Splits

Create them with native keys, move between them with `Navigator.nvim`:

| Keys | Action |
|------|--------|
| `<C-w>v` / `<C-w>s` | Vertical / horizontal split |
| `<C-w>c` / `<C-w>o` | Close split / keep only current |
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
| `<leader>H` | Unpin all files |
| `<leader>1` – `<leader>4` | Jump to pinned file 1–4 |

Para **desfijar un solo archivo**: `<leader>h`, borra su línea con `dd` y guarda sí o sí con `:w` (sin `:w` no se aplica). Ojo: `<leader>h` solo abre/cierra el menú, cerrar así **no** guarda.

Pinned slots show in the statusline as `󰐃 1○ 2● …` — `●` marks the slot of the current buffer.

### Motion & files

| Keys | Action |
|------|--------|
| `s` | Flash jump |
| `<leader>fn` | New file (Genghis) |
| `<leader>fr` | Rename file |
| `<leader>fm` | Move file |
| `<leader>fD` | Trash file |

### Screenshots (sin `freeze`)

| Keys | Action |
|------|--------|
| `<leader>sc` | Screenshot de la selección visual con ray.so (`:Rayso`, necesita internet) |
| `<leader>pv` | Live preview del HTML actual |
| `<leader>pV` | Cerrar el live preview |

### Autopares

`nvim-autopairs` + `nvim-ts-autotag` vienen activos: escribe `{`, `[`, `(`, `"` o `<div>` y se cierra solo. `Alt+e` (`<M-e>`) envuelve la palabra actual con el par.

### Autocompletado (cómo elegir una sugerencia)

Al escribir aparece el menú de `blink.cmp` (LSP + snippets + buffer + rutas):

| Keys | Action |
|------|--------|
| `<C-n>` / `<C-p>` (o `<Down>` / `<Up>`) | Moverse a la siguiente / anterior sugerencia |
| `<CR>` (Enter) | Aceptar la sugerencia resaltada |
| `<C-e>` | Cerrar el menú sin aceptar |
| `<C-Space>` | Forzar que aparezca el menú / ver documentación |
| `<Tab>` / `<S-Tab>` | Saltar al siguiente / anterior hueco del snippet aceptado |
| `<C-b>` / `<C-f>` | Subir / bajar en la documentación |
| `<C-k>` | Ver/ocultar la firma de la función |

> `<CR>` acepta lo resaltado; si no hay nada resaltado hace un Enter normal. El preset es `enter` (ver `keymap.preset` en `lua/plugins/lsp.lua`).

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

1. Abre un archivo `.html` en nvim.
2. Pulsa `<leader>pv` (o ejecuta `:LivePreview`). Se abre `http://localhost:5500` en tu navegador.
3. Edita y guarda (`<C-s>`): el navegador recarga solo.
4. Para detenerlo: `<leader>pV` (o `:LivePreviewClose`).

> El puerto se configura en `lua/plugins/preview.lua` (`opts.port = 5500`).

## Explorer sin abrir/cerrar el tree

El tree lateral ya no te roba el foco: al abrir un archivo con `<CR>` el cursor pasa al buffer y el tree sigue la selección (`update_focused_file`). Para no depender del tree usa **Oil como buffer**:

1. Pulsa `-` (o `<leader>o`): el directorio actual se abre como un buffer normal.
2. Navega con `j/k`, entra con `<CR>`, sube con `-`, crea con `%`, renombra con `R`, borra con `D`.
3. Guarda con `:w` para aplicar los cambios en disco y vuelve con `<C-o>` o cambia de buffer con `<S-h>` / `<S-l>`.

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

## Requirements

- Neovim **0.11.5+**
- `git`, `rg`, `fd`, `node`, `npm`, `python3`
- `tree-sitter` CLI ≥ 0.26.1 (the script installs it if missing)

## Made by  

[maurux01](https://github.com/Maurux01)



