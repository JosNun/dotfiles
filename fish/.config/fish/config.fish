# Ye olde git stuff
alias gco="git checkout"
alias gst="git status"
alias gl="git log"
alias glo="git log --oneline"
alias glog="git log --oneline --graph"

set fish_user_paths (npm bin)

set -U -x GOPATH "/home/josiah/Programming"

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

