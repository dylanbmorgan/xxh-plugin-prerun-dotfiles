#----------------------------------#
#           opening cmds           #
#----------------------------------#

# starship
function starship_transient_prompt_func
    starship module line_break
    # starship module os
    # starship module hostname
    # starship module directory
    # starship module sudo
    # starship module $argv status
    starship module time
    starship module $argv character
end
# function starship_transient_rprompt_func
#     starship module time
# end
starship init fish | source
enable_transience

# thefuck
thefuck --alias | source
# When supported by fish, add --enable-experimental-instant-mode

# zoxide 
zoxide init fish | source

# navi
navi widget fish | source

# pyenv 
# set -Ux PYENV_ROOT $HOME/.pyenv
# fish_add_path $PYENV_ROOT/bin
# pyenv init - fish | source 

# Run neofetch and lsd in interactive terminal only
if ! status -i
    exit
else
    echo -e '\n'
    if [ $hostname = maccie ]
        fastfetch -l mac2
    else
        fastfetch
    end
    # shortcuts.sh
    lsd
end

set -g -x fish_greeting ''

# Use different commands to change stacksize for different machines
if [ $hostname = arch ]
    ulimit -s unlimited
    # fish_ssh_agent
else
    ulimit -s hard
    # fish_ssh_agent
end

#----------------------------------# 
#            alias list            #
#----------------------------------#

# Common configs
alias cf='$EDITOR ~/.config/fish/config.fish'
alias sf='$PAGER ~/.config/fish/config.fish'
alias chstar='$EDITOR ~/.config/starship/starship.toml'
alias seestar='$PAGER ~/.config/starship/starship.toml'
alias chkit='$EDITOR ~/.config/kitty/kitty.conf'
alias skit='$PAGER ~/.config/kitty/kitty.conf | $PAGER -l sh'
alias alieye='alias | $PAGER -l sh'

# Dangerous Commands
alias rm='rm -I -v'
alias mv='mv -v'
alias sup='su -p'
# alias encfs='encfs --idle=10'

# ls and mv
alias ls='lsd --hyperlink=auto'
alias lss='ls -lS' # ls -l and sort by size
alias la='ls -A'
alias lh='ls -hAlt'
alias l1='ls -1'
alias ll='ls -lh'
alias lt='ls --tree'
alias lw='ls | wc -l' # print number of files in directory
alias lrw='ls -R | wc -l'
alias lsblk='lsblk -e 7' # Exclude loops from output 
alias df='df -hT'

# cp
alias nsync='rsync -ah --info=progress2' # cp with progress bar
alias cp='cp -vi'
alias bak='~/bin/bak.sh'
alias x='xclip -selection clipboard' # copy output to clipboard

# Kitty
alias d='kitty +kitten diff'
alias icat='kitty +kitten icat --align left'
alias clear='clear -T kitty'
# alias mdcat='mdcat -p'
alias kkh='kitten ssh'
alias hg='kitten hyperlinked-grep'
alias transfer='kitten transfer'
alias clip='kitten clipboard'

# Compress
alias tarc='tar -czvf' # compress zee vucking file
alias taru='tar -xf' # or xtract file

# Files
alias hb='du -sh * | sort -h | $PAGER -l sh' # print size of each directory/file
alias hbb='du -sh * | sort -h'
alias bye='trash-put -v' # better alt to rm
alias byes='trash-list'
# alias mac-bye='' # TODO add command to move to ~/.Trash on mac
alias dontleaveme='trash-restore'
alias begone='trash-empty'
alias rg='rg -p'
alias sodzilla='ssh -L 8385:localhost:9091 godzilla'

# System
alias nightnight='sudo poweroff'
alias cuagain='sudo pacman -Syu && sudo systemctl reboot'
alias breakme="sudo pacman -Syu && yay -Syu && yay -Yc && doom upgrade && doom sync"
alias gnome-restart='killall -3 gnome-shell'
alias paths='echo $fish_user_paths | tr " " "\n"'
alias ssh='ssh -Y'

# HPC sshfs 
alias e772_home='sshfs archer2_e772:/home/e772/e772/morgs/ /home/sshfs/archer2_e772_home'
alias e772_work='sshfs archer2_e772:/work/e772/e772/morgs/ /home/sshfs/archer2_e772_work'
alias bigchonk='sshfs bigchonk:/home/chem/phrbqv/ /home/sshfs/bigchonk'

# Editors
alias tmacs='emacs -nw' # for terminal emacs (like teamacs ☕)
alias clear_emacs_cache='rm ~/.config/emacs/.local/cache/projectile.cache ~/.config/emacs/.local/cache/treemacs-persist ~/.config/emacs/.local/cache/tramp'
alias apply_jinx_stash='set -g CWD (pwd) && cd ~/.config/emacs/.local/straight/repos/jinx/ && git stash apply && ln -s ~/.config/emacs/.local/straight/repos/jinx/jinx-mod.dylib ~/.config/emacs/.local/straight/build-*/jinx && cd $CWD'
alias hx='helix'

# $PAGER
alias man='batman'
alias bgr='batgrep' # also remember to use rg instead of grep
alias cat='$PAGER'
alias code='prettybat'
alias watch='batwatch'
alias pipe='batpipe'

# Others
alias weath='curl wttr.in/Rugby'
alias ytd='youtube-dl'
alias vik='fish_vi_key_bindings'
alias vir='fish_default_key_bindings'
alias watch='watch -cp'
alias sedit='sudoedit'
alias ptpython="ptpython --config-file $HOME/.config/ptpython/config.py"

#----------------------------------# 
#            Functions             #
#----------------------------------#

# cd and ls in one command 
function c
    if count $argv >/dev/null
        builtin cd "$argv"; and lsd
    else
        builtin cd ~; and lsd
    end
end

# Take STDOUT from previous command and use it as STDIN for another
function rr
    set PREV_CMD (history | head -1)
    set PREV_OUTPUT (eval $PREV_CMD)
    set CMD $argv
    echo "Running '$CMD $PREV_OUTPUT'"
    echo
    eval "$CMD $PREV_OUTPUT"
end

function nuke
    ps aux | grep $argv | sed \$d | awk '{print $2}' | xargs kill -9
end

# function fish_postexec --on-event fish_postexec
#     if test $status -ne 0
#         set_color red
#         echo "✗ $status"
#         set_color normal
#     end
# end

# Check if in vterm in emacs
if [ "$INSIDE_EMACS" = vterm ]
    function clear
        vterm_printf "51;Evterm-clear-scrollback"
        tput clear
    end
end

#----------------------------------# 
#            Bindings              #
#----------------------------------#

# fzf_key_bindings
fzf_configure_bindings --directory=ctrl-s --git_log=alt-g --git_status=ctrl-g --variables=alt-v --processes=alt-x

bind ` accept-autosuggestion
bind ctrl-o down-or-search
bind alt-r transpose-chars
bind alt-z zi

# navi
bind ctrl-m _navi_smart_replace

#----------------------------------# 
#           export list            #
#----------------------------------#

set -Ux MPLBACKEND module://matplotlib-backend-kitty
set -Ux MPLBACKEND_KITTY_SIZING manual
set -gx THEFUCK_OVERRIDDEN_ALIASES 'rm,mv,ls,la,lh,l1,ll,fd,cp,clear,man,cat,lsblk,df,watch,rg,ssh,encfs,mdcat,ptpython'

set fzf_fd_opts --hidden --exclude=.git
set --export FZF_DEFAULT_OPTS --height 70% --margin 2.5% --cycle --layout=reverse
set fzf_preview_dir_cmd lsd --all --color=always

# TODO review these:
if [ $hostname = arch ]
    set -U __done_notification_command "notify-send -i /usr/share/icons/Tela-purple/scalable/apps/terminal.svg \$title \$message"
else if [ $hostname = maccie ]
    set -U __done_notification_command "osascript -e 'display notification "\$message" with title "\$title"'"
end

set -U __done_min_cmd_duration 120000
set -U __done_exclude '(hx|$PAGER|ssh|kkh)'
set -U __done_allow_nongraphical 1

set -Ux SPECIES_DEFAULTS "$HOME/Programming/projects/FHIaims/species_defaults"

#----------------------------------# 
#           export paths           #
#----------------------------------#

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/miniconda3/bin/conda
    eval /opt/miniconda3/bin/conda "shell.fish" hook $argv | source
end
# <<< conda initialize <<<

# uv
fish_add_path "/home/dylanmorgan/.local/bin"
