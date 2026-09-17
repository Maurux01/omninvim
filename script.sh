#!/bin/bash
# simplevim installer:
#  1. actualiza el sistema
#  2. verifica que existe; solo instala lo que falta (incluye nvim si falta)
#  3. copia los archivos del repo a la carpeta default (~/.config/nvim)
# MongoDB se elimino a proposito: mongodb-tools/mongosh no existen en los
# repos oficiales de Arch (solo AUR) y rompian la instalacion.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
REPO_URL="${REPO_URL:-https://github.com/Maurux01/simplevim.git}"
SOURCE_DIR=""
TEMP_DIR=""
WARNINGS=()

warn() {
    WARNINGS+=("$*")
    echo "AVISO: $*" >&2
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "  ✓ $1 already installed"
        return 0
    else
        echo "  ✗ $1 not found"
        return 1
    fi
}

check_python_package() {
    if python3 -c "import $1" >/dev/null 2>&1; then
        echo "  ✓ $1 already installed"
        return 0
    else
        echo "  ✗ $1 not found"
        return 1
    fi
}

detect_distro() {
    if [ ! -f /etc/os-release ]; then
        echo "No se pudo detectar la distro (falta /etc/os-release)" >&2
        return 1
    fi
    # shellcheck disable=SC1091
    . /etc/os-release
    case " ${ID:-} ${ID_LIKE:-} " in
        *"arch"*) echo "Arch" ;;
        *"ubuntu"*|*"debian"*) echo "Debian" ;;
        *"fedora"*) echo "Fedora" ;;
        *)
            echo "Distro no soportada: ${ID:-unknown}" >&2
            return 1
            ;;
    esac
}

# 0. Neovim: si falta, se instala con el gestor de paquetes.
ensure_neovim() {
    echo ""
    echo "Checking Neovim..."
    if ! command -v nvim >/dev/null 2>&1; then
        echo "Neovim no encontrado. Instalandolo..."
        case "$OS" in
            Arch) sudo pacman -S --noconfirm --needed neovim ;;
            Debian) sudo apt-get update && sudo apt-get install -y neovim ;;
            Fedora) sudo dnf install -y neovim ;;
        esac
    fi
    if ! command -v nvim >/dev/null 2>&1; then
        echo "ERROR: no se pudo instalar Neovim." >&2
        return 1
    fi
    echo "  ✓ nvim found: $(command -v nvim)"
    if ! nvim --headless -u NONE -i NONE '+lua if vim.fn.has("nvim-0.11.5") == 0 then vim.cmd("cquit 1") end' +qa; then
        echo "ERROR: se requiere Neovim 0.11.5 o superior." >&2
        return 1
    fi
    echo "  ✓ Neovim version OK"
}

# 1. Actualizar el sistema primero.
update_system() {
    echo ""
    echo "Actualizando el sistema..."
    case "$OS" in
        Arch) sudo pacman -Syu --noconfirm ;;
        Debian) sudo apt-get update && sudo apt-get upgrade -y ;;
        Fedora) sudo dnf upgrade --refresh -y ;;
    esac
}

# Un paquete por argumento: nunca "base-devel gcc" como un solo nombre.
queue_missing() {
    local cmd="$1" arch="$2" debian="$3" fedora="$4"
    if ! check_command "$cmd"; then
        MISSING_ARCH+=("$arch")
        MISSING_DEBIAN+=("$debian")
        MISSING_FEDORA+=("$fedora")
    fi
}

# 2a. Paquetes del sistema: solo instala los faltantes.
install_missing_system_packages() {
    echo ""
    echo "Checking system packages..."

    MISSING_ARCH=()
    MISSING_DEBIAN=()
    MISSING_FEDORA=()

    queue_missing gcc gcc gcc gcc
    queue_missing g++ gcc g++ gcc-c++
    queue_missing make make make make
    queue_missing node nodejs nodejs nodejs
    queue_missing npm npm npm npm
    queue_missing python3 python python3 python3
    if ! python3 -m pip --version >/dev/null 2>&1; then
        echo "  ✗ pip not found"
        MISSING_ARCH+=(python-pip)
        MISSING_DEBIAN+=(python3-pip)
        MISSING_FEDORA+=(python3-pip)
    else
        echo "  ✓ pip already installed"
    fi
    if ! python3 -c "import venv" >/dev/null 2>&1; then
        MISSING_DEBIAN+=(python3-venv)
    fi
    queue_missing git git git git
    queue_missing rg ripgrep ripgrep ripgrep
    queue_missing fd fd fd fd
    queue_missing jq jq jq jq
    queue_missing unzip unzip unzip unzip
    queue_missing curl curl curl curl
    queue_missing tar tar tar tar
    queue_missing wget wget wget wget
    queue_missing psql postgresql-libs postgresql-client postgresql
    queue_missing gh github-cli gh gh

    # freeze CLI (para freeze-code.nvim) es opcional: solo avisa, no instala.
    if ! check_command freeze; then
        warn "freeze CLI no encontrado (necesario para :Freeze). Instalalo desde https://github.com/charmbracelet/freeze"
    fi

    local missing=()
    case "$OS" in
        Arch) missing=("${MISSING_ARCH[@]}") ;;
        Debian) missing=("${MISSING_DEBIAN[@]}") ;;
        Fedora) missing=("${MISSING_FEDORA[@]}") ;;
    esac

    if [ "${#missing[@]}" -eq 0 ]; then
        echo "All system packages already installed!"
        return 0
    fi

    echo ""
    echo "Installing missing packages: ${missing[*]}"
    case "$OS" in
        Arch) sudo pacman -S --noconfirm --needed "${missing[@]}" ;;
        Debian) sudo apt-get install -y "${missing[@]}" ;;
        Fedora) sudo dnf install -y "${missing[@]}" ;;
    esac
}

# 2b. npm: solo lo faltante.
install_missing_npm_packages() {
    echo ""
    echo "Checking npm packages..."

    if ! command -v npm >/dev/null 2>&1; then
        warn "npm no esta disponible, salto paquetes npm."
        return 0
    fi

    MISSING_NPM=()

    check_command ng || MISSING_NPM+=("@angular/cli")
    npm list -g --depth=0 typescript >/dev/null 2>&1 || MISSING_NPM+=("typescript")
    npm list -g --depth=0 ts-node >/dev/null 2>&1 || MISSING_NPM+=("ts-node")

    if [ "${#MISSING_NPM[@]}" -eq 0 ]; then
        echo "All npm packages already installed!"
        return 0
    fi

    echo "Installing missing npm packages: ${MISSING_NPM[*]}"
    if [ "$(id -u)" -eq 0 ]; then
        npm install -g "${MISSING_NPM[@]}" || warn "fallo npm global"
    elif command -v sudo >/dev/null 2>&1; then
        sudo npm install -g "${MISSING_NPM[@]}" || warn "fallo npm global"
    else
        npm install -g "${MISSING_NPM[@]}" || warn "fallo npm global"
    fi
}

# 2c. python: solo lo faltante.
install_missing_python_packages() {
    echo ""
    echo "Checking Python packages..."

    if ! command -v python3 >/dev/null 2>&1; then
        warn "python3 no esta disponible, salto paquetes python."
        return 0
    fi

    MISSING_PYTHON=()

    check_python_package marimo || MISSING_PYTHON+=("marimo")
    check_python_package pandas || MISSING_PYTHON+=("pandas")
    check_python_package numpy || MISSING_PYTHON+=("numpy")
    check_python_package scipy || MISSING_PYTHON+=("scipy")
    check_python_package matplotlib || MISSING_PYTHON+=("matplotlib")
    check_python_package seaborn || MISSING_PYTHON+=("seaborn")
    check_python_package plotly || MISSING_PYTHON+=("plotly")
    check_python_package polars || MISSING_PYTHON+=("polars")
    check_python_package sqlalchemy || MISSING_PYTHON+=("sqlalchemy")
    check_python_package psycopg2 || MISSING_PYTHON+=("psycopg2-binary")
    check_python_package pymongo || MISSING_PYTHON+=("pymongo")
    check_python_package sklearn || MISSING_PYTHON+=("scikit-learn")

    if [ "${#MISSING_PYTHON[@]}" -eq 0 ]; then
        echo "All Python packages already installed!"
        return 0
    fi

    echo "Installing missing Python packages: ${MISSING_PYTHON[*]}"
    if python3 -m pip install --help 2>&1 | grep -q "break-system-packages"; then
        python3 -m pip install --user --break-system-packages "${MISSING_PYTHON[@]}" \
            || warn "fallo pip install (${MISSING_PYTHON[*]})"
    else
        python3 -m pip install --user "${MISSING_PYTHON[@]}" \
            || warn "fallo pip install (${MISSING_PYTHON[*]})"
    fi
}

# 2d. tree-sitter CLI (>= 0.26.1): lo exige nvim-treesitter (main) para
# compilar parsers como html. Intenta paquete nativo, con fallback al
# binario oficial si la distro no lo empaqueta.
install_tree_sitter_cli() {
    echo ""
    echo "Checking tree-sitter CLI..."

    ts_version() {
        command -v tree-sitter >/dev/null 2>&1 || return 1
        tree-sitter --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1
    }

    version_ok() {
        [ -n "${1:-}" ] && [ "$(printf '0.26.1\n%s\n' "$1" | sort -V | head -1)" = "0.26.1" ]
    }

    local ver
    ver="$(ts_version || true)"
    if version_ok "$ver"; then
        echo "  ✓ tree-sitter $ver already installed"
        return 0
    fi
    [ -n "$ver" ] && echo "  ✗ tree-sitter $ver demasiado viejo (se necesita >= 0.26.1)"

    case "$OS" in
        Arch) sudo pacman -S --noconfirm --needed tree-sitter-cli || true ;;
        Fedora) sudo dnf install -y tree-sitter-cli || true ;;
        Debian)
            if apt-cache show tree-sitter-cli >/dev/null 2>&1; then
                sudo apt-get install -y tree-sitter-cli || true
            fi
            ;;
    esac

    ver="$(ts_version || true)"
    if version_ok "$ver"; then
        echo "  ✓ tree-sitter $ver installed"
        return 0
    fi

    install_tree_sitter_cli_fallback
}

install_tree_sitter_cli_fallback() {
    local version="${TREE_SITTER_VERSION:-0.27.0}"
    local arch
    case "$(uname -m)" in
        x86_64) arch="x64" ;;
        aarch64|arm64) arch="arm64" ;;
        *)
            warn "arquitectura $(uname -m) sin binario precompilado de tree-sitter"
            return 1
            ;;
    esac

    local dest="$HOME/.local/bin"
    local url="${TREE_SITTER_URL:-https://github.com/tree-sitter/tree-sitter/releases/download/v${version}/tree-sitter-linux-${arch}.gz}"
    echo "Descargando tree-sitter CLI v${version} a $dest ..."

    mkdir -p "$dest"
    local tmpgz tmpbin
    tmpgz="$(mktemp)" || return 1
    tmpbin="$(mktemp)" || { rm -f "$tmpgz"; return 1; }

    if curl -fsSL -o "$tmpgz" "$url" && [ -s "$tmpgz" ] \
        && gunzip -c "$tmpgz" > "$tmpbin" && [ -s "$tmpbin" ]; then
        install -m 0755 "$tmpbin" "$dest/tree-sitter"
        echo "  ✓ tree-sitter instalado en $dest/tree-sitter"
    else
        warn "no se pudo descargar tree-sitter CLI desde $url"
        rm -f "$tmpgz" "$tmpbin"
        return 1
    fi
    rm -f "$tmpgz" "$tmpbin"

    case ":$PATH:" in
        *":$dest:"*) ;;
        *) warn "$dest no esta en PATH; agrega 'export PATH=\"$dest:\$PATH\"' a tu shell" ;;
    esac
}

resolve_source() {
    if [ -f "$SCRIPT_DIR/init.lua" ] && [ -d "$SCRIPT_DIR/lua" ]; then
        SOURCE_DIR="$SCRIPT_DIR"
    else
        TEMP_DIR="$(mktemp -d -t simplevim-install.XXXXXX)"
        echo "Clonando $REPO_URL en $TEMP_DIR ..."
        git clone --depth 1 "$REPO_URL" "$TEMP_DIR" || return 1
        SOURCE_DIR="$TEMP_DIR"
    fi
}

# 3. Copiar siempre los archivos del repo a la carpeta default (con backup).
setup_neovim_config() {
    echo ""
    echo "Copying config files to $CONFIG_DIR ..."

    if [ ! -f "$SOURCE_DIR/init.lua" ] || [ ! -d "$SOURCE_DIR/lua" ]; then
        echo "ERROR: no se encontro init.lua/lua en $SOURCE_DIR" >&2
        return 1
    fi

    if [ -d "$CONFIG_DIR" ]; then
        local backup="$CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Existing config found. Backup: $backup"
        mv "$CONFIG_DIR" "$backup"
    fi

    mkdir -p "$CONFIG_DIR"
    cp -a "$SOURCE_DIR/init.lua" "$CONFIG_DIR/init.lua"
    cp -a "$SOURCE_DIR/lua" "$CONFIG_DIR/lua"
    if [ -f "$SOURCE_DIR/stylua.toml" ]; then
        cp -a "$SOURCE_DIR/stylua.toml" "$CONFIG_DIR/stylua.toml"
    fi
    echo "Config copiada."
}

# 4. Plugins de Lazy (cubre los 21 de tu lista starred): instala solo faltantes.
install_lazy_plugins() {
    echo ""
    echo "Installing Lazy plugins (missing only)..."

    SIMPLEVIM_INSTALL=1 nvim --headless "+Lazy! install" +qa \
        || warn "fallo Lazy install (abre nvim y corre :Lazy para completarlo)."
}

# 4a. LSP via Mason (idempotente: Mason salta lo ya instalado).
install_language_servers() {
    echo ""
    echo "Installing language servers via Mason..."

    local pkgs=(vtsls tailwindcss-language-server html-lsp css-lsp pyright lua-language-server )
    local all_there=1
    for p in "${pkgs[@]}"; do
        if [ ! -d "$DATA_DIR/mason/packages/$p" ] && [ ! -d "$HOME/.local/share/nvim/mason/packages/$p" ]; then
            all_there=0
            break
        fi
    done
    if [ "$all_there" -eq 1 ]; then
        echo "Language servers already installed!"
        return 0
    fi

    nvim --headless "+MasonInstall ${pkgs[*]}" +qa \
        || warn "MasonInstall devolvio error (revisa con :Mason dentro de nvim)."
}

# 4b. Treesitter parsers (API nueva en Nvim 0.12, vieja en 0.11).
install_treesitter_parsers() {
    echo ""
    echo "Installing Treesitter parsers..."

    SIMPLEVIM_INSTALL=1 nvim --headless \
        "+lua ok, err = pcall(function() require('core.treesitter').install() end); if not ok then vim.api.nvim_err_writeln(tostring(err)); vim.cmd('cquit 1') end" \
        +qa || warn "fallo la instalacion de parsers Treesitter (se reintentan al abrir nvim)."
}

verify_installation() {
    echo ""
    echo "Final verification..."

    echo "System tools:"
    for cmd in gcc g++ make node npm python3 git rg fd jq unzip curl tar wget psql gh freeze; do
        if command -v "$cmd" >/dev/null 2>&1; then
            echo "  ✓ $cmd"
        else
            echo "  ✗ $cmd (opcional o pendiente)"
        fi
    done
    if command -v tree-sitter >/dev/null 2>&1; then
        echo "  ✓ tree-sitter ($(tree-sitter --version 2>/dev/null))"
    else
        echo "  ✗ tree-sitter (requerido por nvim-treesitter)"
    fi

    echo ""
    echo "Neovim config files:"
    local failed=0
    for file in init.lua lua/core/options.lua lua/core/keymaps.lua lua/core/treesitter.lua lua/plugins/dashboard.lua lua/plugins/lsp.lua lua/plugins/ui.lua lua/plugins/workflow.lua lua/plugins/git.lua; do
        if [ -f "$CONFIG_DIR/$file" ]; then
            echo "  ✓ $file ($(wc -l < "$CONFIG_DIR/$file") lines)"
        else
            echo "  ✗ $file"
            failed=1
        fi
    done
    return "$failed"
}

cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

main() {
    OS="$(detect_distro)"
    echo "Starting simplevim smart installation... ($OS)"

    ensure_neovim
    update_system
    install_missing_system_packages
    install_missing_npm_packages
    install_missing_python_packages
    install_tree_sitter_cli || warn "tree-sitter CLI no disponible; la instalacion de parsers puede fallar."
    resolve_source
    setup_neovim_config
    install_lazy_plugins
    install_language_servers
    install_treesitter_parsers
    verify_installation || warn "faltan archivos de config, revisa el backup."
    cleanup

    echo ""
    echo "Installation complete!"
    if [ "${#WARNINGS[@]}" -gt 0 ]; then
        echo ""
        echo "Avisos (${#WARNINGS[@]}):"
        for w in "${WARNINGS[@]}"; do
            echo "  - $w"
        done
    fi
    echo ""
    echo "Quick start:"
    echo "  nvim          - Start Neovim (Lazy + Treesitter terminan solos)"
    echo "  gh auth login - Authenticate GitHub CLI"
}

trap cleanup EXIT
main "$@"
