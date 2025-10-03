#!/usr/bin/env bash
set -e

# === CONFIGURATION ============================================================

config_desktop=dwl
config_custom_keyboard_layout=true
config_extra_packages=()

# === PACKAGES =================================================================

pkglist_essentials=(
	cups
	fuse2
	inotify-tools
	pacman-contrib
	polkit
	stow
	system-config-printer
	usbutils
	xdg-user-dirs
)

pkglist_graphical=(
	feh
	mpv
	pavucontrol
	zathura
	zathura-pdf-mupdf
)

pkglist_internet=(
	firefox
	pdfjs
	yt-dlp
)

pkglist_fonts=(
	inter-font
	noto-fonts-emoji
	ttf-roboto
	ttf-roboto-mono
)

pkglist_programming=(
	bear
	clang
	cloc
	gdb
	linux-headers
	python
	rustup
	zig
)

pkglist_terminal=(
	fd
	htop
	man-db
	man-pages
	neovim
	plocate
	ripgrep
	tree
	tree-sitter-cli
	unzip
	wget
	zsh
)

# === UTILITIES ================================================================

message () {
	echo -e "\e[36m>> $@\e[0m"
}

update_packages () {
	message "updating packages"
	sudo pacman -Syuq --noconfirm
}

install_packages () {
	if [[ $# > 0 ]]; then
		message "installing $@"
		sudo pacman -Sq --noconfirm --needed $@
	fi
}

die () {
	echo -e "\e[31m>> error: $@\e[0m"
	exit 1
}

trap_err () {
	die "command \`$BASH_COMMAND\` failed with exit code \`$?\` (line $BASH_LINENO)"
}

# === MODULES ==================================================================

configure_groups () {
	message "configuring user groups"
	sudo usermod -a -G video "$(whoami)"
	echo 'ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video $sys$devpath/brightness", RUN+="/bin/chmod g+w $sys$devpath/brightness"' | sudo tee /etc/udev/rules.d/backlight.rules
}

disable_pc_speaker () {
	message "disabling pc speaker"
	sudo rmmod pcspkr || true
	sudo rmmod snd_pcsp || true
	echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf
	echo "blacklist snd_pcsp" | sudo tee /etc/modprobe.d/nobeep.conf -a
}

install_dwl () {
	local pkglist=(
		fcft
		foot
		grim
		libinput
		libxcb
		libxkbcommon
		pixman
		slurp
		tllist
		wayland
		wayland-protocols
		wl-clipboard
		wlroots0.19
		wmenu
		xorg-xwayland
	)
	install_packages ${pkglist[@]}
	# TODO: actually install dwl by cloning source and compiling it
}

configure_mirrors () {
	install_packages reflector
	message "configuring mirrors"
	sudo systemctl enable reflector.timer
	sudo systemctl start reflector.service
}

update_dotfiles () {
	message "updating dotfiles"
	mkdir -p "$HOME/bin"
	mkdir -p "$HOME/.config"
	mkdir -p "$HOME/.config/Signal"
	mkdir -p "$HOME/.mozilla/firefox/myprofile"
	rm -f "$HOME/.mozilla/firefox/myprofile/search.json.mozlz4"
	stow -t ~ dots
}

configure_xdg_user_dirs () {
	message "configuring user directories"
	mkdir -p "$HOME/code"
	mkdir -p "$HOME/dl"
	mkdir -p "$HOME/docs"
	mkdir -p "$HOME/img"
	mkdir -p "$HOME/music"
	mkdir -p "$HOME/probe"
	mkdir -p "$HOME/vids"
	mkdir -p "$HOME/tmp"
	xdg-user-dirs-update
}

set_custom_keyboard_layout () {
	message "setting custom keyboard layout"
	sudo cp misc/keyboard-layout.xkb /usr/share/X11/xkb/symbols/demod
	sudo localectl --no-convert set-x11-keymap demod "" "" "ctrl:nocaps,terminate:ctrl_alt_bksp"
}

change_shell_to_zsh () {
	local shell="$(which zsh)"
	if [ ! "$SHELL" = "$shell" ]; then
		message "changing shell to zsh"
		sudo chsh -s "$shell" "$(whoami)"
		rm -f ~/.bash_history
		rm -f ~/.bash_logout
		rm -f ~/.bash_profile
		rm -f ~/.bashrc
	fi
}

install_zsh_plugins () {
	message "installing zsh plugins"
	local plugin_dir="$HOME/.local/share/zsh-plugins"
	mkdir -p "$plugin_dir"
	if [ ! -d "$plugin_dir/zsh-vi-mode" ]; then
		git clone "https://github.com/jeffreytse/zsh-vi-mode.git" "$plugin_dir/zsh-vi-mode" --depth=1
	fi
}

download_nvim_spell_files () {
	local spell_dir="$HOME/.local/share/nvim/site/spell"
	local download_url="http://ftp.vim.org/pub/vim/runtime/spell"
	if [ ! -d "$spell_dir" ]; then
		message "downloading nvim spell files"
		mkdir -p "$spell_dir"
		curl "$download_url/de.utf-8.spl" -o "$spell_dir/de.utf-8.spl"
	fi
}

setup_plocate_database () {
	message "setting up plocate database"
	sudo updatedb
}

setup_cups () {
	message "setting up cups"
	sudo systemctl enable cups.service
	sudo systemctl start cups.service
}

configure_git () {
	message "configuring git"
	git config --global user.name thetek
	git config --global user.email "git@thetek.de"
	git config --global credential.helper store
}

# === MAIN =====================================================================

# ensure that we print an error message when a command fails
trap trap_err ERR

update_packages
configure_mirrors

install_packages ${pkglist_essentials[@]}
install_packages ${pkglist_graphical[@]}
install_packages ${pkglist_internet[@]}
install_packages ${pkglist_fonts[@]}
install_packages ${pkglist_programming[@]}
install_packages ${pkglist_terminal[@]}

case "$config_desktop" in
	"dwl") install_dwl ;;
	*)     die "unsupported desktop setting '$config_desktop'" ;;
esac

if [ "$config_custom_keyboard_layout" = true ]; then
	set_custom_keyboard_layout
fi

configure_groups
disable_pc_speaker
update_dotfiles
#download_nvim_spell_files
configure_xdg_user_dirs
install_zsh_plugins
setup_plocate_database
setup_cups
change_shell_to_zsh
configure_git

install_packages ${config_extra_packages[@]}

echo -e "\e[32m>> success!\e[0m"


# TODO: decide on a font an install it
# TODO: centralise colour handling, maybe?
# TODO: rustup install
# TODO: musescore config
# TODO: rewrite in python with actual config and nicer ui
# TODO: laptop optimisations
