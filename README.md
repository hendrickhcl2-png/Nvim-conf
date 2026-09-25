# Nvim-conf

Personal [AstroNvim](https://github.com/AstroNvim/AstroNvim) v6 configuration, managed with
[lazy.nvim](https://github.com/folke/lazy.nvim).

Language support is pulled in through [AstroCommunity](https://github.com/AstroNvim/astrocommunity)
packs for **Lua, TypeScript/JavaScript, HTML/CSS, JSON, Tailwind CSS, Go, SQL and Python**, themed
with [tokyonight](https://github.com/folke/tokyonight.nvim).

---

## 1. Core requirements

These are mandatory — Neovim will not work correctly without them.

| Dependency | Why | Notes |
| --- | --- | --- |
| **Neovim >= 0.11** (stable) | AstroNvim v6 hard requirement (`:checkhealth astronvim` errors below this) | Nightly is not officially supported |
| **git** | lazy.nvim bootstrap, plugin install/update, Mason downloads | |
| **A C compiler** (`gcc`/`clang` + `make`) | Building Tree-sitter parsers and native plugin bits | |
| **Tree-sitter CLI** | Parser compilation (`auto_install` is on) | Auto-installed via Mason if missing |
| **curl** / **wget**, **unzip**, **tar**, **gzip** | Mason package downloads and extraction | |
| **A Nerd Font** | Icons in the statusline, file tree, tabline | Install it locally **and** select it in your terminal profile |
| **True-color terminal** | tokyonight colors | kitty, WezTerm, Alacritty, Ghostty, iTerm2, modern GNOME Terminal |
| **Clipboard tool** | System clipboard integration (`:h clipboard-tool`) | `wl-clipboard` on Wayland, `xclip`/`xsel` on X11, built in on macOS |

## 2. Language toolchains

Mason installs the language servers, formatters, linters and debug adapters, but it needs the
matching runtime on the machine to do so. Install the toolchain for each language you actually use:

| Toolchain | Needed for | Mason packages that depend on it |
| --- | --- | --- |
| **Node.js + npm** | TypeScript, HTML/CSS, JSON, Tailwind, Python type checking | `vtsls`, `js-debug-adapter`, `html-lsp`, `css-lsp`, `emmet-ls`, `json-lsp`, `tailwindcss-language-server`, `basedpyright` |
| **Python 3 + pip + venv** | Python, SQL linting | `black`, `isort`, `debugpy`, `sqlfluff` |
| **Go** | Go, SQL language server | `gopls`, `delve`, `goimports`, `gomodifytags`, `gotests`, `iferr`, `impl`, `sqls` |

Lua tooling (`lua-language-server`, `stylua`, `selene`) ships as prebuilt binaries and needs no extra
runtime. `selene` is skipped automatically on `aarch64`.

Node and Python are also used by AstroNvim's REPL terminal mappings (`<Leader>tn`, `<Leader>tp`).

## 3. Optional but recommended

Everything here is optional — Neovim starts fine without it, and `:checkhealth astronvim` reports
these as warnings rather than errors.

| Tool | What it unlocks |
| --- | --- |
| **ripgrep** (`rg`) | Live-grep pickers (`<Leader>fw`, `<Leader>fW`) |
| **fd** | Faster file pickers |
| **lazygit** | Git TUI (`<Leader>gg` / `<Leader>tl`) |
| **gdu** | Disk-usage viewer (`<Leader>tu`) |
| **bottom** (`btm`) | Process/system monitor (`<Leader>tt`) |
| **xdg-open** / `open` | `gx` — open the URL or file under the cursor |

## 4. Installing the dependencies

### Fedora

```shell
sudo dnf install -y neovim git gcc make curl unzip tar gzip wl-clipboard \
  nodejs npm python3 python3-pip golang \
  ripgrep fd-find lazygit
# optional extras
sudo dnf install -y gdu bottom
```

### Arch Linux

```shell
sudo pacman -S --needed neovim git base-devel curl unzip tar gzip wl-clipboard \
  nodejs npm python python-pip go \
  ripgrep fd lazygit gdu bottom tree-sitter-cli
```

### Debian / Ubuntu

```shell
sudo apt install -y git build-essential curl unzip tar gzip wl-clipboard \
  nodejs npm python3 python3-pip python3-venv golang-go \
  ripgrep fd-find
```

Debian/Ubuntu repos often lag behind on Neovim — grab the stable AppImage or the
[official tarball](https://github.com/neovim/neovim/releases/tag/stable) instead of `apt install neovim`
if the packaged version is below 0.11. `lazygit`, `gdu` and `bottom` are usually not packaged; install
them from their GitHub releases.

### macOS (Homebrew)

```shell
brew install neovim git curl unzip node python go ripgrep fd lazygit gdu bottom tree-sitter
xcode-select --install   # C compiler
```

### Nerd Font

Pick one from [nerdfonts.com](https://www.nerdfonts.com/font-downloads), or:

```shell
# Fedora
sudo dnf install -y jetbrains-mono-nerd-fonts
# Arch
sudo pacman -S ttf-jetbrains-mono-nerd
# macOS
brew install --cask font-jetbrains-mono-nerd-font
```

Then set that font as your terminal's font face. If you don't want a Nerd Font, set
`icons_enabled = false` in `lua/lazy_setup.lua`.

## 5. Installing this config

Back up anything already there:

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

Clone and start:

```shell
git clone https://github.com/hendrickhcl2-png/Nvim-conf ~/.config/nvim
nvim
```

On first launch lazy.nvim bootstraps itself, installs every plugin pinned in `lazy-lock.json`, and
Mason begins downloading the language servers and tools. Let it finish (watch `:Lazy` and `:Mason`),
then restart Neovim.

Verify the setup:

```vim
:checkhealth astronvim
:checkhealth
:Mason
```

## 6. What's in here

```
init.lua                  lazy.nvim bootstrap (don't edit)
lazy-lock.json            pinned plugin revisions
lua/lazy_setup.lua        AstroNvim v6 spec, leader keys (<Space> / ,), lazy options
lua/community.lua         AstroCommunity language packs + tokyonight
lua/polish.lua            last-run hook (disabled)
lua/plugins/
  astroui.lua             colorscheme = tokyonight
  tokyonight.lua          transparent sidebars and floats
  sql.lua                 nanotee/sqls.nvim on sql/mysql/plsql filetypes
  toggleterm.lua          custom floating terminal: <C-\> or :FloatTerm
  astrocore.lua           template (disabled — remove the `if true then return` guard to use)
  astrolsp.lua            template (disabled)
  mason.lua               template (disabled)
  none-ls.lua             template (disabled)
  treesitter.lua          template (disabled)
  user.lua                template (disabled)
```

Files marked *disabled* start with `if true then return {} end`. Delete that line to activate them.

### Tools Mason installs from this config

- **LSP:** `lua_ls`, `vtsls`, `html`, `cssls`, `emmet_ls`, `jsonls`, `tailwindcss`, `gopls`, `sqls`, `basedpyright`
- **Formatters / linters:** `stylua`, `selene`, `black`, `isort`, `sqlfluff`, `goimports`
- **Debug adapters:** `js-debug-adapter`, `debugpy`, `delve`
- **Go helpers:** `gomodifytags`, `gotests`, `iferr`, `impl`

## 7. Maintenance

```vim
:Lazy update          " update plugins and refresh lazy-lock.json
:Lazy sync
:Mason               " manage LSP/DAP/linter/formatter packages
:TSUpdate            " update Tree-sitter parsers
```

Commit `lazy-lock.json` after updating so other machines get the same plugin revisions.
