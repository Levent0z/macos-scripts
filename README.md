# macos-scripts

> Scripts mostly for my own use.

These scripts were originally written for bash. In October 2021, I switched to zsh.

## Disclaimer

Correctness of any kind is not guaranteed. Use at your own risk.

## How To Use

1. Clone this repo
2. Run `my_prereq.sh`
3. Update your shell initialization script to call `my.sh`
4. Restart your terminal

In other words:

```sh
mkdir -p ~/github/levent0z
cd ~/github/levent0z
git clone https://github.com/Levent0z/macos-scripts.git
./my_prereq.sh
 # if using zsh:
echo 'source "$HOME/github/levent0z/macos-scripts/my.sh"' >> ~/.zshrc
# if using bash
echo 'source "$HOME/github/levent0z/macos-scripts/my.sh"' >> ~/.bash_profile
```
