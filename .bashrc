# .bashrc
#set -x

## ===================================================================
## Basic bash configuration
## ===================================================================
# Source global bashrc if we're interactive.
case "$-" in
    *i*)
        [ -r /etc/bashrc ] && . /etc/bashrc ;;
    *)
    ;;
esac
# restrictive umask
umask 0077
# On Fedora/CentOS/RHEL at least, make this 256 color terminal for
# remote connections. See /etc/profile.d/256term.sh.
SEND_256_COLORS_TO_REMOTE=1

export PATH="$HOME/bin:$PATH:$HOME/.local/bin"

# -------------------------------------------------------------------
# Various bash options
# -------------------------------------------------------------------
shopt -s checkhash
shopt -s checkjobs
shopt -s checkwinsize
shopt -s direxpand
shopt -s dirspell
shopt -s extglob
shopt -s globstar
shopt -s hostcomplete
shopt -s progcomp
shopt -s sourcepath
shopt -s xpg_echo
IGNOREEOF=2
MAILCHECK=0

## ===================================================================
## bash command history setup
## ===================================================================
shopt -s cmdhist
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s lithist
HISTTIMEFORMAT="%F/%T  "
HISTCONTROL=ignoreboth
HISTIGNORE="?:??"
HISTSIZE=2000
HISTFILESIZE=2000
history -r

## ===================================================================
## $PAGER / less(8) options
## ===================================================================
export PAGER="less"
export LESS="FiJMnQRsW#.5"
export SYSTEMD_LESS="FRXMK"
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
# Widespread less hack for color in man pages (deplored by less author).
#export LESS_TERMCAP_mb=$'\E[01;31m'
#export LESS_TERMCAP_md=$'\E[01;31m'
#export LESS_TERMCAP_me=$'\E[0m'
#export LESS_TERMCAP_se=$'\E[0m'
#export LESS_TERMCAP_so=$'\E[01;44;33m'
#export LESS_TERMCAP_ue=$'\E[0m'
#export LESS_TERMCAP_us=$'\E[01;32m'

## ===================================================================
## man(8) options
## ===================================================================
export MANOPT="--no-hyphenation --no-justification"

## ===================================================================
## cd options and hacks
## ===================================================================
shopt -s autocd
shopt -s cdspell
shopt -s cdable_vars
# export CDPATH=
function mycd() {
    case "$@" in
        "")
            pushd "${HOME}"
            ;;
        "-")
            popd > /dev/null
            ;;
        "--")
            _cd "$(dirs +1)" && popd -n +1 > /dev/null
            ;;
        *)
            pushd "$1"
    esac
}
alias cd=mycd
alias _cd="builtin cd"

# make a dir and change to it
function mkcd() { mkdir -p "$@" && eval cd "\"\$$#\""; }
alias nd=mkcd

## ===================================================================
## Prompt
## ===================================================================
PROMPT_DIRTRIM=3
## -------------------------------------------------------------------
# colors (assuming solarized)
# --------------------------------------------------------------------
Reset='\[\e[00m\]'
Red='\[\e[31m\]'
Orange='\[\e[1;31m\]'
Green='\[\e[32m\]'
Yellow='\[\e[33m\]'
Blue='\[\e[34m\]'
Cyan='\[\e[36m\]'
White='\[\e[37m\]'
## -------------------------------------------------------------------
#  some fun with last exit status
## -------------------------------------------------------------------
eval "$(locale -k charmap)"
if [ "$charmap" = "UTF-8" ]; then
    Goodsigns='☺☻☸☮♡♫'
else
    Goodsigns='*¤+'
fi
export Goodsigns

# Show previous error code if it's not 0 or
# show a smiley if it is.
show_error() {
    local rc=$?
    local Smiley="${Goodsigns:$(( ${RANDOM} % ${#Goodsigns})):1}"
    case $TERM in
        *color*)
            if [ $rc -ne 0 ]; then
                echo "(${Orange}${rc}${Reset})"
            else
                echo "${Green}${Smiley}${Reset}"
            fi
            ;;
        *)
            if [ $rc -ne 0 ]; then
                echo "(${rc})"
            else
                echo "${Smiley}"
            fi
            ;;
    esac
}

xtitle() {
    case $TERM in
        *xterm*)
            XTITLE='\[\033]0;\u@\h:\w\007\]' ;;
        *)
            XTITLE='' ;;
    esac
    echo "$XTITLE"
}

## -------------------------------------------------------------------
#  Git status
## -------------------------------------------------------------------
# We are using the upstream git-prompt.sh if available.
# Change the order if a custom version is needed.
for p in "/usr/share/git-core/contrib/completion/git-prompt.sh" \
             "$HOME/.local/lib/git/git-prompt.sh" \
             "$HOME/.git-prompt.sh"; do
    if [ -r $p ]; then
        source $p
        export GIT_PS1_SHOWDIRTYSTATE=1
        export GIT_PS1_SHOWSTASHSTATE=1
        export GIT_PS1_SHOWUNTRACKEDFILES=1
        export GIT_PS1_SHOWUPSTREAM=auto
        case $TERM in
            *color*)
                export GIT_PS1_SHOWCOLORHINTS=1 
                PROMPT_COMMAND='__git_ps1 "$(xtitle)$(show_error)\! \u@${Green}\h${Reset}:\w"\
                          "${Yellow}\\\$${Reset} "'
                ;;
            *)
                export GIT_PS1_SHOWCOLORHINTS=0
                PROMPT_COMMAND='__git_ps1 "$(xtitle)$(show_error)\! \u@\h:\w" "\\\$ "'
                ;;
        esac
        break
    fi
done



# if [ -n $INSIDE_EMACS -o $TERM = "dumb" ]; then
#     PS1="${PS1PRE}${PS1POST}"
# else 
#     case $TERM in
#         xterm*color)
        
#     esac
# fi

# my_prompt_command(){
#     local Last_exit=$?
#     history -a
#     local Smiley="${Goodsigns:$(( ${RANDOM} % ${#Goodsigns})):1}"
#     if [ $Last_exit -eq 0 ]; then
#         PS1="${Green}${Smiley}${Reset}"
#     else
#         PS1="[${Orange}${Last_exit}${Reset}]"
#     fi
#     PS1+="$(\!) \u@${Green}\h:${White}\w\${Reset} \$"
# }


## ===================================================================
## aliases and functions
## ===================================================================
showcolors16() {
    local T='Love'   # The test text
    echo -e "\n    fg   bg>    40m     41m     42m     43m     44m     45m     46m     47m";
    for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
                       '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
                       '  36m' '1;36m' '  37m' '1;37m'; do
        FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
            echo -en "\033[$FG\033[$BG  $T  \033[0m";
        done
        echo;
    done
    echo
}

# aliases
alias bc="bc -lq"
alias p88="ping 8.8.8.8"
alias p44="ping 8.8.4.4"
#alias myip='dig @208.67.222.220 myip.opendns.com +short'
alias pubip='dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d \"'

## ===================================================================
## Python
## ===================================================================
# virtualenvwrapper
# these may need setting
# VIRTUALENVWRAPPER_PYTHON=
# VIRTUALENVWRAPPER_VIRTUALENV=
if [ $(which virtualenvwrapper.sh > /dev/null 2>&1) ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Projects
    source virtualenvwrapper.sh
fi
## ===================================================================
## Ruby
## ===================================================================
# chruby
declare -a chrubypaths=( "/usr/share/chruby" "$HOME/.local/share" )
for crp in "${chrubypaths[@]}"; do
    crp="$crp/chruby.sh"
    [ -r "$crp" ] && source "$crp" && break
done

## ===================================================================
## Go-lang
## ===================================================================
export GOPATH="$HOME/Code/go/"
export PATH=$PATH:$GOPATH/bin

## ===================================================================
## The One True Editor (or that other one)
## ===================================================================
if [ $(which emacs > /dev/null 2>&1) ]; then
    export EDITOR="emacsclient -n -c -a emacs"
elif [ $(which vim > /dev/null 2>&1) ]; then
    export EDITOR=vim
    alias vi=vim
else
    export EDITOR=vi
fi
alias e="$EDITOR "

## ===================================================================
## GPG
## ===================================================================
if [ -x /usr/bin/gpg2 ]; then
    alias gpg=/usr/bin/gpg2
fi

# if we're in a desktop session on Linux, configure gpg-agent
if [ $DESKTOP_SESSION ]; then 
    # let gpg-agent know where we are
    GPG_TTY=$(tty)
    export GPG_TTY
    # ping gpg-agent for ssh support
    /usr/bin/gpg-connect-agent /bye && \
        unset SSH_AGENT_PID SSH_ASKPASS SSH_AUTH_SOCK GPG_AGENT_PID
    if [ -S "${HOME}/.gnupg/S.gpg-agent.ssh" ]; then
        export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
    fi
fi


