# qnvim
## Introduction
This is my personal configuration for neovim, mainly based on kickstart.nvim but I refactored it to improve maintainability. Feel free to use it!
## Installation
### Install Neovim
See their official site (https://neovim.io/)
Or use package manager to install (e.g. homebrew on mac)
### Install Dependencies
- git
- make
- unzip
- C compiler, e.g. gcc
- ripgrep (https://github.com/BurntSushi/ripgrep#installation)
- A nerd font to provide icons (https://www.nerdfonts.com/)
### Install Qnvim
Backup your previous configuration before installing!
For mac users and linux users
```bash
cp ~/.config/nvim ~/.config/nvim-bak
```

Then clone the repo to your config directory.
For Linux and Mac users, do
```bash
git clone https://github.com/QiuMatthew/qnvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```
For Windows users, if you're using `cmd`
```bash
git clone https://github.com/QiuMatthew/qnvim.git %userprofile%\AppData\Local\nvim\
```
if you are using `powershell`
```bash
git clone https://github.com/QiuMatthew/qnvim.git $env:USERPROFILE\AppData\Local\nvim\
```
## Getting Started
Just start neovim and wait for the installation to complete.
```
nvim
```
That's it, enjoy!
## Keybinds
Key mapping is highly customizable, I basically adopt the default settings from plugin authors.

### GitHub Integration
Navigate directly from your code to GitHub pages:

| Key | Description |
|-----|-------------|
| `<leader>gh` | Open current file in GitHub browser |
| `<leader>gc` | Open GitHub commit page for current line |
| `<leader>gp` | Open GitHub pull request page for current line |

**Features:**
- Works with both SSH and HTTPS GitHub remotes
- Uses `git blame` to find the commit that last modified the current line
- Automatically searches for associated pull requests
- Opens pages at the exact line number you're viewing

