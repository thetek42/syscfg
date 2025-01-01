#!/usr/bin/env bash
set -e

# === CONFIGURATION ============================================================

config_desktop=i3
config_custom_keyboard_layout=true
config_extra_packages=()

# === PACKAGES =================================================================

pkglist_essentials=(
	pacman-contrib
	polkit
	stow
	xdg-user-dirs
)

pkglist_graphical=(
	alacritty
	feh
	#gimp
	#inkscape
	#libreoffice-fresh
	mpv
	#obs-studio
	pavucontrol
	zathura
	zathura-djvu
	zathura-pdf-mupdf
)

pkglist_internet=(
	firefox
	pdfjs
	qutebrowser
	yt-dlp
)

pkglist_fonts=(
	inter-font
	noto-fonts-emoji
)

pkglist_programming=(
	bear
	clang
	cloc
	cmake
	jdk-openjdk
	linux-headers
	lua-language-server
	nodejs
	python
)

pkglist_terminal=(
	fd
	htop
	man-db
	man-pages
	neovim
	plocate
	ripgrep
	rustup
	tldr
	tmux
	tree
	tree-sitter-cli
	unzip
	wget
	zsh
)

pkglist_tex=(
	texlive
)

pkglist_games=(
	prismlauncher
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

install_i3 () {
	local pkglist=(
		adwaita-cursors
		dmenu
		i3
		numlockx
		polybar
		xclip
		xorg-server
		xorg-xinit
		xorg-xrandr
	)

	install_packages ${pkglist[@]}
}

update_dotfiles () {
	message "updating dotfiles"
	stow -t ~ dots
}

configure_xdg_user_dirs () {
	message "configuring user directories"
	mkdir -p "$HOME/bin"
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
		local user="$(whoami)"
		sudo chsh -s "$shell" "$user"
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

# === MAIN =====================================================================

# ensure that we print an error message when a command fails
trap trap_err ERR

update_packages

install_packages ${pkglist_essentials[@]}
install_packages ${pkglist_graphical[@]}
install_packages ${pkglist_internet[@]}
install_packages ${pkglist_fonts[@]}
install_packages ${pkglist_programming[@]}
install_packages ${pkglist_terminal[@]}
install_packages ${pkglist_tex[@]}
install_packages ${pkglist_games[@]}

case "$config_desktop" in
	"i3") install_i3 ;;
	*)    die "unsupported desktop setting '$config_desktop'" ;;
esac

if [ "$config_custom_keyboard_layout" = true ]; then
	set_custom_keyboard_layout
fi

download_tex_utils
update_dotfiles
download_nvim_spell_files
configure_xdg_user_dirs
install_zsh_plugins
change_shell_to_zsh

install_packages ${config_extra_packages[@]}

echo -e "\e[32m>> success!\e[0m"


# TODO: decide on a font an install it
# TODO: firefox config (?)
# TODO: centralise colour handling, maybe?
# TODO: dmenu config
# TODO: rustup install
# TODO: prevent ~/perl5 dir
