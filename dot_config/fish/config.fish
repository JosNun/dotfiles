# Ye olde git stuff
alias gco="git checkout"
alias gst="git status"
alias gl="git log"
alias glo="git log --oneline"
alias glog="git log --oneline --graph"
alias unmerged="git branch -a  --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' --no-merge"

# Homebrew
set -gx HOMEBREW_PREFIX "/opt/homebrew";
set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar";
set -gx HOMEBREW_REPOSITORY "/opt/homebrew";
set -q PATH; or set PATH ''; set -gx PATH "/opt/homebrew/bin" "/opt/homebrew/sbin" $PATH;
set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/opt/homebrew/share/man" $MANPATH;
set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH;

set -gx EDITOR "nvim"

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

set -gx RUN_PKGSITE_WITH_VSCODE 1
set -gx RUN_SLOW_GO_TESTS_ON_PRE_PUSH 1

fish_add_path /opt/homebrew/bin

fish_add_path (npm bin)

fish_add_path ~/go/bin

# set -U fish_user_paths /opt/homebrew/bin $fish_user_paths

# set fish_user_paths (npm bin)

# set -U -x GOPATH "/home/josiah/Programming"

alias ls="lsd"

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/josiahnunemaker/google-cloud-sdk/path.fish.inc' ]; . '/Users/josiahnunemaker/google-cloud-sdk/path.fish.inc'; end

starship init fish | source

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/josiahnunemaker/.lmstudio/bin
