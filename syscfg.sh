#!/usr/bin/env bash
set -e

# === PACKAGES =================================================================

packages=(
	bear
	clang
	cloc
	cups
	fd
	feh
	firefox
	fuse2
	gdb
	go
	gopls
	htop
	inotify-tools
	inter-font
	linux-headers
	lua-language-server
	man-db
	man-pages
	mpc
	mpd
	mpv
	neovim
	noto-fonts-cjk
	noto-fonts-emoji
	pacman-contrib
	pavucontrol
	plocate
	polkit
	python
	python-pip
	python-pipx
	ripgrep
	rustup
	stow
	system-config-printer
	tree
	tree-sitter-cli
	ttf-roboto
	ttf-roboto-mono
	unzip
	usbutils
	wget
	xdg-user-dirs
	yt-dlp
	zathura
	zathura-pdf-mupdf
	zig
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

install_sway () {
	local pkglist=(
		fcft
		grim
		slurp
		sway
		sway-contrib
		wl-clipboard
		wmenu
		xorg-xwayland
	)
	install_packages ${pkglist[@]}
}

compile_custom_programs () {
	make -C tsl
	killall tsl || true
	rm -f "$HOME/bin/tsl"
	cp tsl/tsl "$HOME/bin"
}

configure_mirrors () {
	install_packages reflector
	message "configuring mirrors"
	sudo systemctl enable reflector.timer
	sudo systemctl start reflector.service
}

update_dotfiles () {
	message "updating dotfiles"
	./update_dotfiles.sh
}

configure_xdg_user_dirs () {
	message "configuring user directories"
	mkdir -p "$HOME/code"
	mkdir -p "$HOME/dl"
	mkdir -p "$HOME/docs"
	mkdir -p "$HOME/img"
	mkdir -p "$HOME/music"
	mkdir -p "$HOME/playlists"
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

setup_services () {
	message "setting up services"
	sudo systemctl --now enable cups.service
	systemctl --user --now enable mpd.service
}

# === MAIN =====================================================================

# ensure that we print an error message when a command fails
trap trap_err ERR

update_packages
configure_mirrors

install_packages ${packages[@]}
install_sway
compile_custom_programs
set_custom_keyboard_layout
configure_groups
disable_pc_speaker
update_dotfiles
#download_nvim_spell_files
configure_xdg_user_dirs
install_zsh_plugins
setup_plocate_database
setup_services
change_shell_to_zsh

echo -e "\e[32m>> success!\e[0m"


# TODO: decide on a font an install it
# TODO: centralise colour handling, maybe?
# TODO: rustup install
# TODO: musescore config
# TODO: rewrite in python with actual config and nicer ui
# TODO: laptop optimisations
