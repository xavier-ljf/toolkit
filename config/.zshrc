export PATH="/opt/homebrew/bin:$PATH"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Zsh completion setup
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

alias l="ls -alh"
alias c="clear"
alias ofd="open ."

alias proxy-on="export http_proxy=http://127.0.0.1:7897 https_proxy=http://127.0.0.1:7897; \
    git config --global http.proxy socks5://127.0.0.1:7897; \
    git config --global https.proxy socks5://127.0.0.1:7897"
alias proxy-off="unset http_proxy https_proxy; \
    git config --global --unset http.proxy; \
    git config --global --unset https.proxy"

eval "$(starship init zsh)"
