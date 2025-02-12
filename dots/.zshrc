## completion
autoload -Uz compinit
compinit
zstyle ":completion:*" menu select

## prompt
autoload -Uz promptinit
promptinit
prompt_mytheme_setup () {
	PS1=" %F{2}%~%f %(?.%F{8}\$%f.%F{1}\$%f) "
}
prompt_themes+=(mytheme)
prompt mytheme

## history
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$cache_dir"
HISTFILE="$cache_dir/zsh_history"
HISTSIZE=10000
SAVEHIST=10000

## environment variables
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="nvim \"+set signcolumn=no\" +Man!"

## path
typeset -U path PATH
path=(
	~/.local/bin
	~/bin
	$path
)
export PATH

## aliases
# editor
alias e="nvim"
alias vi="nvim"
alias vim="nvim"
# ls
alias ls="ls --color=auto -h"
alias l="ls -1"
alias ll="ls -l"
alias la="ls -lA"
# git
alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gacampf="git add --all && git commit --amend --no-edit && git push --force-with-lease"
alias gb="git branch"
alias gbc="git branch --show-current"
alias gc="git commit"
alias gcam="git commit --amend --no-edit"
alias gcl="git clone"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gh="git stash --include-untracked"
alias ghp="git stash pop"
alias gl="git pull"
alias glo="git log --oneline"
alias glog="git log"
alias gm="git merge"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpo="git push origin \$(git branch --show-current)"
alias gr="git rebase"
alias gra="git rebase --abort"
alias grc="git rebase --continue"
alias grm="git rebase main"
alias grs="git restore"
alias grt="git reset"
alias gst="git status"
# misc
alias ..="cd .."
alias md="mkdir"
alias chx="chmod +x"
alias wcl="wc -l"
alias py="python3"
alias grep="grep --color=auto"
alias cdconf="cd ~/code/syscfg/dots/.config"

## utilities
mcd () {
	mkdir -p -- "$1" &&
	cd -P -- "$1"
}
watchmake () {
    while inotifywait -e close_write "$1"; do
        make
    done
}
za () {
    zathura "$1" & disown
}

## keybindings
source "$HOME/.local/share/zsh-plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

if [ -f "$HOME/.zcustom" ]; then
    source "$HOME/.zcustom"
fi
