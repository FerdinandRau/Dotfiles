setopt always_to_end
setopt auto_cd
setopt auto_list
setopt auto_menu
setopt glob_dots
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt menu_complete
setopt no_beep
setopt prompt_subst

ZDATDIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
ZTMPDIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

HISTFILE="$ZDATDIR/history"
HISTSIZE=100000
SAVEHIST=100000

autoload -Uz colors && colors
autoload -Uz compinit && compinit -C -d "$ZTMPDIR/compdump"
autoload -Uz vcs_info && precmd_functions+=(vcs_info)

zstyle ':completion:*' cache-path "$ZTMPDIR/compcache"
zstyle ':completion:*' complete-options true
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-cache on
zstyle ':completion:::::' completer _expand _complete _ignored _approximate
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%F{magenta}%b%f)'

PROMPT="(%F{blue}%n%f %F{cyan}%~%f) %F{green}λ%f "
RPROMPT="\$vcs_info_msg_0_"

precmd() {
	precmd() {
		echo
	}
}

plugin() {
	if [ -d "$ZDATDIR/plugins/$1" ]; then
		name="$(echo $1 | cut -d "/" -f 5)"
		[ -f "$ZDATDIR/plugins/$1/$name.zsh" ] &&
			source "$ZDATDIR/plugins/$1/$name.zsh"
		[ -f "$ZDATDIR/plugins/$1/$name.plugin.zsh" ] &&
			source "$ZDATDIR/plugins/$1/$name.plugin.zsh"
	else
		git clone -q --depth 1 "$1" "$ZDATDIR/plugins/$1"
		plugin $1 && print -P "%F{green}Installed%f [$1]"
	fi
}

plugin_update() {
	rm -rf "$ZDATDIR/plugins"
	source "${ZDOTDIR:-$HOME}/.zshrc"
}

plugin "https://github.com/zsh-users/zsh-completions"
plugin "https://github.com/zsh-users/zsh-syntax-highlighting"
