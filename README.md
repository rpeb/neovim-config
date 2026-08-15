# Neovim Config

## Table of Contents

- [General](#general)
- [Vim Navigation (Advanced)](#vim-navigation-advanced)
- [Navigation](#navigation)
- [Moving Blocks (Visual)](#moving-blocks-visual)
- [Copy / Delete](#copy--delete)
- [File Navigation (Oil)](#file-navigation-oil)
- [File Navigation (Yazi)](#file-navigation-yazi)
- [Telescope](#telescope)
- [LSP](#lsp)
- [Formatting (Conform)](#formatting-conform)
- [C/C++ Build (CMake)](#cc-build-cmake)
- [Java](#java)
- [Debug (DAP)](#debug-dap)
- [Git (Gitsigns)](#git-gitsigns)
- [Git (Diffview)](#git-diffview)
- [Git (Octo)](#git-octo)
- [Quickfix / Location List](#quickfix--location-list)
- [Trouble](#trouble)
- [Flash (Jump)](#flash-jump)
- [Surround (nvim-surround)](#surround-nvim-surround)
- [Search / Replace](#search--replace)
- [Obsidian](#obsidian)
- [HTTP Client (Kulala)](#http-client-kulala)
- [Overseer (Task Runner)](#overseer-task-runner)
- [Other Plugins](#other-plugins)
- [Themes (Themery)](#themes-themery)
- [Terminal](#terminal)
- [Tmux (vim-tpipeline)](#tmux-vim-tpipeline)
- [Vim Defaults](#vim-defaults)

## Vim Navigation (Advanced)

These are built-in vim motions and text objects — no plugins needed. Learn these and you'll fly through code.

### Motions (combine with operators like `d`, `c`, `y`)

| Key | Action |
|-----|--------|
| `w` / `W` | Jump to start of next word/WORD |
| `e` / `E` | Jump to end of word/WORD |
| `b` / `B` | Jump to start of previous word/WORD |
| `0` | Start of line |
| `^` | First non-blank character |
| `$` | End of line |
| `gg` / `G` | Top / bottom of file |
| `5G` / `:15` | Go to line 15 |
| `%` | Jump to matching bracket |
| `{` / `}` | Jump to previous/next blank line (paragraph) |
| `(` / `)` | Jump to previous/next sentence |
| `H` / `M` / `L` | Top / middle / bottom of screen |
| `<C-o>` / `<C-i>` | Jump list backward / forward |
| `;` / `,` | Repeat last `f`/`t` forward/backward |

### Text Objects (combine with `d`, `c`, `y`, `v`)

| Key | Selects |
|-----|---------|
| `iw` / `aw` | Inner word / a word (with surrounding space) |
| `i"` / `a"` | Inside quotes / around quotes |
| `i(` / `a(` | Inside parens / around parens |
| `i{` / `a{` | Inside braces / around braces |
| `i[` / `a[` | Inside brackets / around brackets |
| `i<` / `a<` | Inside angle brackets / around them |
| `it` / `at` | Inside HTML tag / around HTML tag |
| `iW` / `aW` | Inner WORD / a WORD |

### Operators (combine with motions/text objects)

| Key | Action |
|-----|--------|
| `d{motion}` | Delete (e.g. `diw` delete inner word, `d$` delete to end) |
| `c{motion}` | Change (delete and enter insert mode) |
| `y{motion}` | Yank |
| `v{motion}` | Visual select |
| `V` | Visual line select |
| `<C-v>` | Visual block select |
| `>` / `<` | Indent / dedent (combine with motion: `>ip` indent paragraph) |
| `=` | Auto-indent (combine with motion: `=ip` indent paragraph) |
| `gu` / `gU` | Lowercase / uppercase (e.g. `guw` lowercase word) |
| `gq` | Format text to textwidth (e.g. `gqap` format paragraph) |

### Useful Combos

| Combo | Action |
|-------|--------|
| `ciw` | Change inner word |
| `ci"` | Change inside quotes |
| `da(` | Delete around parentheses |
| `yiw` | Yank inner word |
| `dip` | Delete inner paragraph |
| `>ip` | Indent paragraph |
| `=ip` | Re-indent paragraph |
| `gUiw` | Uppercase inner word |
| `gqap` | Reformat paragraph |
| `cib` | Change inside block |
| `dit` | Delete inside HTML tag |
| `yip` | Yank inner paragraph |
| `Vp` | Replace line with yanked text |
| `*` / `#` | Search word under cursor forward/backward |
| `gd` | Go to local definition |
| `gD` | Go to global definition |
| `<C-a>` / `<C-x>` | Increment / decrement number |
| `mi` / `mI` | Set mark i / jump to mark i |
| `J` (visual) | Join selected lines |
| `U` (visual) | Lowercase |

### Window / Tab Motions

| Key | Action |
|-----|--------|
| `<C-w>w` | Switch to next window |
| `<C-w>h/j/k/l` | Switch to window in direction |
| `<C-w>v` | Vertical split |
| `<C-w>s` | Horizontal split |
| `<C-w>q` | Close window |
| `<C-w>o` | Close all other windows |
| `<C-w>=` | Equalize window sizes |
| `gt` / `gT` | Next / previous tab |
| `{count}gt` | Go to tab number |

## General

| Key | Mode | Action |
|-----|------|--------|
| `jj` | Insert | Exit insert mode |
| `Y` | Normal | Yank to end of line (like `C`/`D`) |
| `==` | Normal | Select all |
| `<leader><leader>` | Normal | Source current file |
| `<leader>q` | Normal | Close buffer |
| `<leader>w` | Normal | Close buffer, retain split |
| `<leader>x` | Normal | Make file executable |
| `Q` | Normal | Disabled (no Ex mode) |

## Navigation

| Key | Mode | Action |
|-----|------|--------|
| `J` / `K` / `<C-d>` / `<C-u>` | Normal | Keep cursor centered |
| `n` / `N` | Normal | Keep search results centered |
| `<S-h>` / `<S-l>` | Normal/Visual | Jump to start/end of line |
| `<C-h/j/k/l>` | Normal | Move to split (smart-splits) |
| `<C-\>` | Normal | Move to previous split |
| `<A-h/j/k/l>` | Normal | Resize split (smart-splits) |
| `<leader><leader>h/j/k/l` | Normal | Swap buffer in direction |
| `<C-S-Down/Up>` | Normal | Resize horizontal split |
| `<C-Left/Right>` | Normal | Resize vertical split |
| `gj` / `gk` | Normal | Jump between markdown headers |

## Moving Blocks (Visual)

| Key | Mode | Action |
|-----|------|--------|
| `J` / `K` | Visual | Move block down/up |
| `<` / `>` | Visual | Indent/dedent and stay selected |
| `p` | Visual | Paste without overwriting register |
| `//` | Visual | Search for highlighted text |

## Copy / Delete

| Key | Mode | Action |
|-----|------|--------|
| `<leader>y` | Normal/Visual | Yank to system clipboard |
| `<leader>Y` | Normal | Yank line to system clipboard |
| `<leader>d` | Normal/Visual | Delete without overwriting register |
| `<leader>cf` | Normal | Copy file name to clipboard |
| `<leader>cp` | Normal | Copy full file path to clipboard |

## File Navigation (Oil)

| Key | Mode | Action |
|-----|------|--------|
| `-` | Normal | Open parent directory (Oil) |

## File Navigation (Yazi)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | Normal | Open Yazi file manager |
| `<leader>Ye` | Normal | Open Yazi in cwd |

## Telescope

| Key | Mode | Action |
|-----|------|--------|
| `<leader>sf` | Normal | Search files |
| `<leader>sg` | Normal | Live grep |
| `<leader>sw` | Normal/Visual | Search word under cursor |
| `<leader>sh` | Normal | Search help tags |
| `<leader>sk` | Normal | Search keymaps |
| `<leader>ss` | Normal | Select Telescope builtin |
| `<leader>sd` | Normal | Search diagnostics |
| `<leader>sr` | Normal | Resume last search |
| `<leader>s.` | Normal | Search recent files |
| `<leader>sc` | Normal | Search commands |
| `<leader>sF` | Normal | Frecency search |
| `<leader>/` | Normal | Fuzzy search in current buffer |
| `<leader>fp` | Normal | Copy file path |

## LSP

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to definition |
| `gr` | Normal | References |
| `K` | Normal | Hover docs |
| `<leader>vca` | Normal | Code action |
| `<leader>vrn` | Normal | Rename |
| `<leader>vws` | Normal | Workspace symbol |
| `<leader>vd` | Normal | Show diagnostics |
| `[d` / `]d` | Normal | Next/previous diagnostic |
| `grr` | Normal | LSP references (Telescope) |
| `gri` | Normal | LSP implementations |
| `grd` | Normal | LSP definitions |
| `grt` | Normal | LSP type definitions |
| `gO` | Normal | Document symbols |
| `gW` | Normal | Workspace symbols |
| `<C-h>` | Insert | LSP signature help |

## Formatting (Conform)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>f` | Normal | Format buffer |

Format-on-save is enabled. Respects project config files where present:

- **C/C++**: clang-format (uses the project's `.clang-format`; skipped if none exists)
- **Lua**: stylua (uses the project's `.stylua.toml`)

## Git (Gitsigns)

| Key | Mode | Action |
|-----|------|--------|
| `]c` / `[c` | Normal | Next/previous git change |
| `<leader>hs` | Normal/Visual | Stage hunk |
| `<leader>hr` | Normal/Visual | Reset hunk |
| `<leader>hS` | Normal | Stage buffer |
| `<leader>hu` | Normal | Undo stage hunk |
| `<leader>hR` | Normal | Reset buffer |
| `<leader>hp` | Normal | Preview hunk |
| `<leader>hb` | Normal | Blame line |
| `<leader>hd` | Normal | Diff against index |
| `<leader>hD` | Normal | Diff against last commit |
| `<leader>tb` | Normal | Toggle line blame |
| `<leader>tD` | Normal | Toggle inline deleted |

## Git (Diffview)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gd` | Normal | Open Diffview |
| `<leader>gD` | Normal | Close Diffview |
| `<leader>gh` | Normal | File history |
| `<leader>gH` | Normal | Full history |
| `<leader>gf` | Normal | Focus files panel |

## Git (Octo)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>goi` | Normal | GitHub issues |
| `<leader>gop` | Normal | GitHub PRs |
| `<leader>god` | Normal | GitHub discussions |
| `<leader>gon` | Normal | GitHub notifications |

## Quickfix / Location List

| Key | Mode | Action |
|-----|------|--------|
| `<leader>h` | Normal | Next quickfix item |
| `<leader>;` | Normal | Previous quickfix item |
| `<leader>qc` | Normal | Toggle quickfix list |
| `<leader>k` | Normal | Next location list item |
| `<leader>j` | Normal | Previous location list item |

## Trouble

| Key | Mode | Action |
|-----|------|--------|
| `<leader>xx` | Normal | Toggle diagnostics |
| `<leader>xX` | Normal | Buffer diagnostics |
| `<leader>xL` | Normal | Location list |
| `<leader>xQ` | Normal | Quickfix list |
| `<leader>xs` | Normal | Document symbols |
| `<leader>xr` | Normal | LSP references |

## Flash (Jump)

| Key | Mode | Action |
|-----|------|--------|
| `s` | Normal/Visual/Operator | Flash jump to any position |
| `S` | Normal/Operator/Visual | Flash jump with treesitter (select groups) |
| `<C-s>` | Command | Toggle flash search in cmdline |

## Surround (nvim-surround)

| Key | Mode | Action |
|-----|------|--------|
| `ys{motion}{char}` | Normal | Add surround (e.g. `ysiw"`, `ysa)'`) |
| `ds{char}` | Normal | Delete surround (e.g. `ds"`, `ds(`) |
| `cs{old}{new}` | Normal | Change surround (e.g. `cs"'`, `cs("`) |
| `S{char}` | Visual | Surround selection |

## Search / Replace

| Key | Mode | Action |
|-----|------|--------|
| `<leader>s` | Normal | Replace word under cursor in buffer |

## Obsidian

| Key | Mode | Action |
|-----|------|--------|
| `<leader>on` | Normal | New note |
| `<leader>oq` | Normal | Quick switch |
| `<leader>oc` | Normal | Toggle checkbox |
| `<leader>ot` | Normal | Insert template |
| `<leader>ob` | Normal | Backlinks |
| `<leader>ol` | Normal | Links |
| `<leader>of` | Normal | Follow link |
| `<leader>od` | Normal | Daily notes |
| `<leader>os` | Normal | Search notes |
| `<leader>ott` | Normal | Tags list |
| `<leader>otoc` | Normal | Table of contents |
| `<leader>opi` | Normal | Paste image |
| `<leader>ok` | Normal | Move to zettelkasten |
| `<leader>ow` | Normal | Move to work |
| `<leader>odd` | Normal | Delete file in buffer |

## C/C++ Build (CMake)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cc` | Normal | CMake configure |
| `<leader>cb` | Normal | CMake build |
| `<leader>cB` | Normal | CMake build (clean) |
| `<leader>ct` | Normal | CMake run test |
| `<leader>cR` | Normal | CMake run |
| `<leader>cS` | Normal | CMake stop |
| `<leader>cC` | Normal | CMake clean |
| `<leader>cK` | Normal | CMake select kit |
| `<leader>cV` | Normal | CMake select build type |
| `<leader>cA` | Normal | CMake launch args |
| `<leader>cG` | Normal | CMake open build generator |
| `<leader>cO` | Normal | CMake close build generator |
| `<leader>ch` | Normal | CMake header info (Telescope) |

## Debug (DAP)

| Key | Mode | Action |
|-----|------|--------|
| `<F5>` | Normal | Start/continue debugging |
| `<F1>` | Normal | Step into |
| `<F2>` | Normal | Step over |
| `<F3>` | Normal | Step out |
| `<F7>` | Normal | Toggle DAP UI |
| `<leader>db` | Normal | Toggle breakpoint |
| `<leader>B` | Normal | Conditional breakpoint |
| `<leader>E` | Normal | Exception breakpoints |
| `<leader>dx` | Normal | Terminate debug session |
| `<leader>dl` | Normal | Run last / REPL |
| `<leader>dt` | Normal | Debug nearest test (neotest) |
| `<leader>dr` | Normal | Open REPL float |
| `<leader>ds` | Normal | Open scopes float |
| `<leader>df` | Normal | Open stacks float |
| `<leader>do` | Normal | Toggle DAP UI |
| `<leader>dh` | Normal | Debug hover |
| `<leader>dS` | Normal | Debug scopes |
| `<leader>dF` | Normal | Debug frames |
| `<leader>di` | Normal | Debug inspect (REPL) |
| `<leader>de` | Normal | Debug exception breakpoints |
| `<leader>dR` | Normal | Debug run replay |
| `<leader>dg` | Normal | Debug switch gdb/lldb |

## HTTP Client (Kulala)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>Rs` | Normal | Send HTTP request |
| `<leader>Rb` | Normal | Open scratchpad |

## Overseer (Task Runner)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>or` | Normal | Run task |
| `<leader>oT` | Normal | Toggle task list |
| `<leader>oS` | Normal | Open shell |

## Other Plugins

| Key | Mode | Action |
|-----|------|--------|
| `<leader>Z` | Normal | Open Zoxide |
| `<leader>ut` | Normal | Toggle transparency |
| `<leader>tz` | Normal | Toggle Zen mode |
| `<leader>bd` | Normal | Open buffer dashboard |
| `<leader>ao` | Normal | Toggle Aerial outline |
| `<leader>cs` | Visual | CodeSnap to clipboard |
| `<leader>cS` | Visual | CodeSnap save to file |
| `<leader>cA` | Visual | CodeSnap ASCII to clipboard |
| `<leader>cn` | Normal | Neogen code annotation |
| `<leader>lq` | Normal | LeetCode dashboard |
| `<leader>i` | Normal | Import picker |
| `<leader>nd` | Normal | Dismiss Noice message |
| `<leader>vpp` | Normal | Open init.lua |

## Themes (Themery)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tc` | Normal | Open theme picker (Themery) |

The selected theme persists across sessions (saved to
`~/.local/share/nvim/themery/state.json`). Press `<cr>` to apply and save,
`q` / `<Esc>` to cancel, and use `j`/`k` (or arrows) to preview with
livePreview.

Available themes (variants selectable in the picker):

- **Catppuccin** (default)
- **Nord**
- **Kanagawa** (dragon, wave, lotus)
- **Material** (darker, lighter, oceanic, palenight)
- **Everforest** (dark, light)
- **One Dark Pro** (onedark, onedark_dark, onedark_vivid, onelight)
- **GitHub** (dark, light, dark_dimmed, light_default)
- **Bamboo**
- **Gruvbox**
- **Monokai** (pro, soda, ristretto)
- **Tokyo Night** (night, storm, moon, day)
- **Rosé Pine** (default, moon, dawn)
- **Nightfox** (nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox)
- **Dracula**
- **Gruvbox Material** (hard, medium, soft)
- **Sonokai** (default, atlantis, andromeda, shusia, maia, espresso)
- **Oxocarbon**
- **Solarized 8** (default, flat, high, low, light)

## Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<Esc><Esc>` | Terminal | Exit terminal mode |
| `<C-t>` | Terminal | Exit terminal mode (alt) |
| `<leader>jk` | Normal | Kill terminal job |

## Tmux (vim-tpipeline)

Automatically merges Neovim's statusline with tmux's statusline. No keymaps needed — just works.

## Vim Defaults

| Key | Mode | Action |
|-----|------|--------|
| `<C-o>` | Normal | Jump to previous location |
| `<C-i>` | Normal | Jump to next location |
