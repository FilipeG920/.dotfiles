# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# loads ble.sh
[[ $- == *i* ]] && source -- ~/.local/share/blesh/ble.sh --attach=none

# activate starship
eval "$(starship init bash)"
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'

# update fastfetch function
updatefetch() {
	cd ~/Downloads || return
	wget -O fastfetch-linux-amd64.deb https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb
	sudo apt install ./fastfetch-linux-amd64.deb
	rm -f fastfetch-linux-amd64.deb
}
# update neovim function
update-all() {
	echo "==> Atualizando a lista de pacotes..."
	sudo apt update || return 1

	echo "==> Atualizando sistema..."
	sudo apt upgrade -y || return 1

	echo "==> Removendo pacotes desnecessários..."
	sudo apt autoremove -y || return 1

	echo "==> Limpando cache..."
	sudo apt autoclean || return 1

	nvim-update || return 1

	echo "==> Tudo atualizado com sucesso."
}
nvim-update() {
	local TMP_FILE="/tmp/nvim-linux-x86_64.tar.gz"
	local INSTALL_DIR="/opt/nvim"

	echo "==> Verificando versão do Neovim..."

	local current_version=$(nvim --version | head -n1 | awk '{print $2}')
	local latest_version=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest \
		| grep '"tag_name"' \
		| cut -d '"' -f 4)

	if [ -z "$latest_version" ]; then
		echo "Erro ao obter a última versão do GitHub."
		return 1
	fi

	echo "Versão atual : $current_version"
	echo "Última versão: $latest_version"

	if [ "$current_version" = "$latest_version" ]; then
		echo "==> Neovim já está atualizado."
		return 0
	fi

	echo "==> Nova versão detectada. Atualizando..."

	curl -L \
	  https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
	  -o "$TMP_FILE" || {
	    echo "Erro ao baixar Neovim."
	    return 1
	  }

	sudo rm -rf "$INSTALL_DIR" || return 1
	sudo tar -C /opt -xzf "$TMP_FILE" || return 1
	sudo mv /opt/nvim-linux-x86_64 "$INSTALL_DIR" || return 1
	sudo ln -sf "$INSTALL_DIR/bin/nvim" /usr/local/bin/nvim || return 1

	rm -f "$TMP_FILE"

	echo "==> Atualização concluída."
	nvim --version | head -n 1
}

# Automatic github authentication
eval "$(ssh-agent -s)" >/dev/null
ssh-add ~/.ssh/id_ed25519 2>/dev/null

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Added by `rbenv init` on qua 06 ago 2025 17:30:32 -03
eval "$(~/.rbenv/bin/rbenv init - --no-rehash bash)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export CLASSPATH=/home/filipe/Downloads/weka-3-8-6/mysql-connector-j-9.5.0.jar

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#Put your Brave installation location here
export CHROME_EXECUTABLE="/opt/brave.com/brave/brave-browser"

# Java 17 version
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Golang Environment Variable
export PATH=$PATH:/usr/local/go/bin

# NeoVim path
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH=$HOME/.local/bin:$PATH

# Flutter
export PATH="$HOME/Flutter/flutter/bin:$PATH"

# Change default editor to NeoVim
export EDITOR=nvim

# Bin install Env Var
export PATH="$HOME/bin:$PATH"

# autosuggestion Fish Style
bleopt complete_auto_complete=1
bleopt complete_auto_history=1
bleopt complete_auto_delay=100

# Zsh style menu when using TAB
bleopt complete_menu_complete=1
bleopt complete_menu_filter=1
bleopt complete_menu_style=align-nowrap
bleopt complete_ambiguous=1

# Shows automatic menu after small pause
bleopt complete_auto_menu=500

# Things I'll understand in the future
bleopt complete_ambiguous=1
bleopt complete_auto_menu=1
bleopt complete_auto_complete=1

if [[ $TERM == "xterm-kitty" ]]; then
    fastfetch
fi

[[ ! ${BLE_VERSION-} ]] || ble-attach
. "$HOME/.cargo/env"


# Added by Antigravity CLI installer
export PATH="/home/filipe/.local/bin:$PATH"
eval "$(uv generate-shell-completion bash)"
eval "$(uvx --generate-shell-completion bash)"
