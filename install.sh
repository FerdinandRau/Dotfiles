#!/bin/sh

sh() {
	rm -f "$HOME/.profile"
	rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/sh"
	rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/shell"

	mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/sh"

	cp sh/profile "${XDG_CONFIG_HOME:-$HOME/.config}/sh"
}

zsh() {
	[ "$(command -v zsh)" ] || return
	[ "$(command -v sudo)" ] || return

	rm -f "$HOME/.zshenv"
	rm -f "$HOME/.zshrc"
	rm -f "$HOME/.zprofile"
	rm -f "$HOME/.zsh_history"
	rm -rf "$HOME/.zsh_sessions"
	rm -rf "$ZDOTDIR"
	rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
	rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
	rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

	mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
	mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
	mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

	if [ -d /etc/zsh ]; then
		env=/etc/zsh/zshenv
	else
		env=/etc/zshenv
	fi

	sudo rm -f "$env"
	sudo zsh -c "echo 'ZDOTDIR=\"\${XDG_CONFIG_HOME:-\$HOME/.config}/zsh\"' >>$env"

	cp zsh/.zshrc "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

	if [ "$(uname)" == "Darwin" ]; then
		sudo zsh -c "echo 'SHELL_SESSIONS_DISABLE=1' >>$env"

		echo "" >>"${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
		echo "export HOMEBREW_NO_ENV_HINTS=1" >>"${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
		echo "export HOMEBREW_NO_AUTO_UPDATE=1" >>"${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"

		if [ "$(uname -m)" == "arm64" ]; then
			echo "" >>"${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
			echo '[ -d /opt/homebrew ] && eval "$(/opt/homebrew/bin/brew shellenv)"' >>"${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
		elif [ "$(uname -m)" == "x86_64"]; then
			echo "" >>"${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
			echo '[ -d /usr/local/bin ] && export PATH="/usr/local/bin:$PATH"' >>"${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
		fi
	fi

	echo "" >>"${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
	echo '[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/sh/profile" ] && emulate sh -c "source \"${XDG_CONFIG_HOME:-$HOME/.config}/sh/profile\""' >>"${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
}

git() {
	[ "$(command -v git)" ] || return

	rm -f "$HOME/.gitconfig"
	rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/git"

	mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/git"
	touch "${XDG_CONFIG_HOME:-$HOME/.config}/git/config"

	echo
	echo "         Git Credentials         "
	echo "---------------------------------"
	read -p "Name  : " name
	read -p "Email : " email
	echo

	command git config --global core.editor nvim
	command git config --global init.defaultBranch master
	command git config --global user.name "$name"
	command git config --global user.email "$email"

	if [ "$(uname)" == "Darwin" ]; then
		command git config --global credential.helper osxkeychain
	else
		command git config --global credential.credentialStore secretservice
	fi
}

"$1"
