# qnvim
## Introduction
This is my personal configuration for neovim, mainly based on kickstart.nvim but I refactored it to improve maintainability.Feel free to use it!
## Installation
### Install Neovim

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
