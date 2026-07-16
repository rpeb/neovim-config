# Neovim Config

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

## Neo-tree

| Key | Mode | Action |
|-----|------|--------|
| `\` | Normal | Reveal file in Neo-tree |
| `<leader>et` | Normal | Toggle Neo-tree |
| `<leader>eb` | Normal | Open buffer list (float) |

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

## Java

| Key | Mode | Action |
|-----|------|--------|
| `<leader>jj` | Normal | Compile and run current Java file |
| `<leader>jmr` | Normal | Build and run in terminal split |
| `<leader>jmb` | Normal | Build only |
| `<leader>jmt` | Normal | Run tests |
| `<leader>jmi` | Normal | Full install build |
| `<leader>jsh` | Normal | Open interactive shell |

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
| `<leader>tc` | Normal | Theme chooser (Themery) |
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

## Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<Esc><Esc>` | Terminal | Exit terminal mode |
| `<C-t>` | Terminal | Exit terminal mode (alt) |
| `<leader>jk` | Normal | Kill terminal job |

## Vim Defaults

| Key | Mode | Action |
|-----|------|--------|
| `<C-o>` | Normal | Jump to previous location |
| `<C-i>` | Normal | Jump to next location |
