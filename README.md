# syscfg

## Usage

On first install:

1. Install [Arch Linux](https://archlinux.org)
2. `sudo pacman -S git`
3. `git clone https://git.tjdev.de/thetek/syscfg --depth=1`
4. `cd syscfg`
5. Edit `syscfg.sh` to your liking
6. `./syscfg.sh`

After changes, it is sufficient to run either:
- `./syscfg.sh` to apply everything again (also includes an update of all packages)
- `./update_dotfiles.sh` when only the dotfiles have to be synchronised

## Contents

| Path           | Purpose                                    |
| -------------- | ------------------------------------------ |
| syscfg.sh      | Main system setup script                   |
| dots/          | Dotfiles, will be symlinked to ~ by stow   |
| dots/.config/  | Main directory for configuration files     |
| dots/.mozilla/ | Custom firefox profile configuration       |
| dots/bin       | Utility shell scripts                      |
| misc/          | Miscellaneous stuff (e.g. keyboard layout) |
| wlock/         | Screen locker (wlock with configs)         |
