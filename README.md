## Sync `.config` directory with GNU Stow

```
mkdir ~/dotfiles && cd ~/dotfiles
git clone https://github.com/Jikol/dotfiles-wsl-debian.git .
stow --target=$HOME .
```
