# ~/.zshrc
# Configuração básica para Zsh no Arch Linux

# ------------------------------------------------------------
# Só continua se o shell for interativo
# ------------------------------------------------------------
# Evita carregar aliases, completion, starship etc. em scripts.
[[ $- != *i* ]] && return

# ------------------------------------------------------------
# Completion do Zsh
# ------------------------------------------------------------
# Carrega o sistema de autocompletar do Zsh.
autoload -Uz compinit

# Menu interativo ao apertar TAB.
zstyle ':completion:*' menu select

# Completion ignorando diferença entre maiúsculas e minúsculas.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Usa cores no menu de completion, se LS_COLORS estiver definido.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Evita duplicar barras em caminhos.
zstyle ':completion:*' squeeze-slashes true

# Inicializa completion.
compinit

# ------------------------------------------------------------
# Histórico
# ------------------------------------------------------------
# Arquivo onde o histórico será salvo.
HISTFILE="$HOME/.zsh_history"

# Quantidade de comandos mantidos na sessão atual.
HISTSIZE=1000

# Quantidade de comandos salvos no arquivo.
SAVEHIST=10000

# Salva comandos no histórico incrementalmente.
setopt INC_APPEND_HISTORY

# Adiciona ao histórico em vez de sobrescrever.
setopt APPEND_HISTORY

# Compartilha histórico entre terminais abertos.
setopt SHARE_HISTORY

# Ignora comandos duplicados consecutivos.
setopt HIST_IGNORE_DUPS

# Remove duplicatas antigas quando o mesmo comando aparece de novo.
setopt HIST_IGNORE_ALL_DUPS

# Não salva comandos que começam com espaço.
setopt HIST_IGNORE_SPACE

# Remove espaços desnecessários antes de salvar no histórico.
setopt HIST_REDUCE_BLANKS

# Mostra o comando expandido antes de executar, útil com histórico tipo `!!`.
setopt HIST_VERIFY

# Salva timestamp no histórico.
setopt EXTENDED_HISTORY

# ------------------------------------------------------------
# Comportamento geral do shell
# ------------------------------------------------------------
# Permite digitar apenas o nome de um diretório para entrar nele.
# setopt AUTO_CD

# Usa stack de diretórios com `cd`, permitindo navegação com `pushd/popd`.
# setopt AUTO_PUSHD

# Evita diretórios duplicados na stack.
setopt PUSHD_IGNORE_DUPS

# Permite comentários em comandos interativos.
# Exemplo: pacman -Syu  # atualizar sistema
setopt INTERACTIVE_COMMENTS

# Desativa beep chato do terminal.
setopt NO_BEEP

# ------------------------------------------------------------
# PATH
# ------------------------------------------------------------
# Remove entradas duplicadas automaticamente.
typeset -U path PATH

# Caminhos pessoais e ferramentas instaladas manualmente.
# No Arch, programas instalados via pacman normalmente já ficam em /usr/bin.
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/develop/flutter/bin"
  "$HOME/.ghcup/bin"
  "$HOME/.local/share/gem/ruby/3.4.0/bin"
  $path
)

# Go instalado manualmente em /usr/local/go.
# Se você instalou Go via pacman, não precisa disso.
# [[ -d /usr/local/go/bin ]] && path=("/usr/local/go/bin" $path)

# Neovim instalado manualmente em /opt/nvim.
# Se você instalou via pacman, ele já estará em /usr/bin/nvim.
# [[ -d /opt/nvim/bin ]] && path=("/opt/nvim/bin" $path)


export PATH="$HOME/.cargo/bin:/usr/lib/rustup/bin:$PATH"
export PATH

# ------------------------------------------------------------
# Variáveis de ambiente
# ------------------------------------------------------------
# Editor padrão.
export EDITOR="nvim"
export VISUAL="nvim"

# Pager padrão.
export PAGER="less"

# Mantém cores em comandos que usam less.
export LESS="-R"

# Java 17 no Arch.
# No Arch, o caminho padrão costuma ser este:
if [[ -d /usr/lib/jvm/default ]]; then
  export JAVA_HOME="/usr/lib/jvm/default"
  path=("$JAVA_HOME/bin" $path)
fi

# Brave para Flutter/Web.
# No Arch, geralmente o binário fica em /usr/bin/brave.
# if command -v brave >/dev/null 2>&1; then
#   export CHROME_EXECUTABLE="$(command -v brave)"
# elif command -v brave-browser >/dev/null 2>&1; then
#   export CHROME_EXECUTABLE="$(command -v brave-browser)"
# fi

# ------------------------------------------------------------
# Apply pywal theme on all new terminal windows
# ------------------------------------------------------------
# (cat ~/.cache/wal/sequences &)

# ------------------------------------------------------------
# Starship prompt
# ------------------------------------------------------------
# Substitui PS1. Por isso não precisa configurar prompt manualmente.
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ------------------------------------------------------------
# Título da janela do terminal
# ------------------------------------------------------------
# Mostra usuário@máquina:diretório no título do terminal.
_set_terminal_title() {
  case "$TERM" in
    xterm*|rxvt*|screen*|tmux*|alacritty*|foot*|kitty*)
      print -Pn "\e]0;%n@%m: %~\a"
      ;;
  esac
}

precmd_functions+=(_set_terminal_title)

# ------------------------------------------------------------
# Cores e aliases básicos
# ------------------------------------------------------------
# Ativa cores em ls/grep.
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Aliases úteis.
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'

# Substitutos melhores para fgrep/egrep.
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'

# ------------------------------------------------------------
# Funções de atualização no Arch
# ------------------------------------------------------------
# Atualiza fastfetch pelo pacman.
updatefetch() {
  echo "==> Atualizando fastfetch..."
  sudo pacman -Syu fastfetch
}

# Atualiza Neovim pelo pacman.
# No Arch, o ideal é instalar Neovim via pacman:
# sudo pacman -S neovim
nvim-update() {
  if pacman -Qi neovim >/dev/null 2>&1; then
    echo "==> Atualizando Neovim pelo pacman..."
    sudo pacman -Syu neovim
  else
    echo "Neovim não parece estar instalado via pacman."
    echo "Instale com:"
    echo "  sudo pacman -S neovim"
    return 1
  fi
}

# Atualização geral do sistema.
update-all() {
  echo "==> Atualizando sistema..."

  if command -v yay >/dev/null 2>&1; then
    yay -Syu || return 1
  else
    sudo pacman -Syu || return 1
  fi

  echo "==> Removendo pacotes órfãos, se existirem..."
  local orphans
  orphans="$(pacman -Qtdq 2>/dev/null)"

  if [[ -n "$orphans" ]]; then
    sudo pacman -Rns $orphans || return 1
  else
    echo "Nenhum pacote órfão encontrado."
  fi

  echo "==> Limpando cache do pacman, se paccache estiver disponível..."
  if command -v paccache >/dev/null 2>&1; then
    sudo paccache -r
  else
    echo "Para limpeza melhor de cache, instale:"
    echo "  sudo pacman -S pacman-contrib"
  fi

  echo "==> Tudo atualizado."
}

# ------------------------------------------------------------
# SSH Agent
# ------------------------------------------------------------
# Evita iniciar um ssh-agent novo toda vez que abrir o terminal.
# Só tenta adicionar a chave se já existir um agente ativo.
# if [[ -n "$SSH_AUTH_SOCK" && -f "$HOME/.ssh/id_ed25519" ]]; then
#   ssh-add -l >/dev/null 2>&1 || ssh-add "$HOME/.ssh/id_ed25519" >/dev/null 2>&1
# fi

# ------------------------------------------------------------
# Alert para comandos longos
# ------------------------------------------------------------
# Uso:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([[ $? = 0 ]] && echo terminal || echo error)" "$(fc -ln -1)"'

# ------------------------------------------------------------
# Arquivo separado para aliases pessoais
# ------------------------------------------------------------
# Coloque aliases extras em ~/.zsh_aliases para não poluir o .zshrc.
if [[ -f "$HOME/.zsh_aliases" ]]; then
  source "$HOME/.zsh_aliases"
fi

# ------------------------------------------------------------
# rbenv
# ------------------------------------------------------------
# Ruby version manager.
# No Arch, instale se precisar:
# sudo pacman -S rbenv ruby-build
# if command -v rbenv >/dev/null 2>&1; then
#   eval "$(rbenv init - zsh)"
# fi

# ------------------------------------------------------------
# SDKMAN
# ------------------------------------------------------------
# Gerenciador de SDKs Java/Kotlin/Gradle etc.
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# ------------------------------------------------------------
# NVM
# ------------------------------------------------------------
# Node Version Manager.
# Se você instalou nvm manualmente, isso carrega o nvm no Zsh.
export NVM_DIR="$HOME/.nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi

# ------------------------------------------------------------
# Rust/Cargo
# ------------------------------------------------------------
# Carrega ambiente do Rust, se existir.
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# ------------------------------------------------------------
# uv / uvx completion
# ------------------------------------------------------------
# Completion para uv e uvx no Zsh.
if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi

if command -v uvx >/dev/null 2>&1; then
  eval "$(uvx --generate-shell-completion zsh)"
fi

# ------------------------------------------------------------
# Fastfetch ao abrir o Kitty
# ------------------------------------------------------------
# Mostra fastfetch somente no Kitty.
if [[ "$TERM" == "xterm-kitty" ]] && command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi
