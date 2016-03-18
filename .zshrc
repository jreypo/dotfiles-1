# vim:foldmethod=marker

#
# Add custom directory for my functions to fpath
#
# fpath=($fpath ~/.zshfunctions)
fpath=($fpath ~/.zsh)

# {{{ The following lines were added by compinstall
zstyle :compinstall filename '/home/jkr/.zshrc'

autoload -Uz compinit
compinit
# }}}

# {{{ Spped up autocompletion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' hosts off
zstyle ':completion:*:git:*' tag-order 'common-commands'

#
# Disable autocompletion from getting git info
#
__git_files () {
    _wanted files expl 'local files' _files
}
# }}}

# {{{ Setup environment
#
# Load $fg & co with color codes
#
autoload -U colors && colors

#
# Ensure user binaries are available.
#
export PATH=$PATH:${HOME}/bin

#
# Set language in shell
#
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"

export EDITOR=vim

# }}}


# {{{ Behavior
bindkey -e
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# Remember history
HISTSIZE=1000
HISTFILE=~/.history
SAVEHIST=1000
# }}}

# {{{ Functions

#
# Add a project to the list of projects to load in tmux
#
function _add_curr_dir_to_projects() {
    local PROJNAME=$1

    #
    # Check if we already have the dir for this project cached.
    #
    if [[ -f ~/.projecthist ]]; then
        if [[ -n "$(grep "^$PROJNAME:" ~/.projecthist | cut -d: -f2)" ]]; then
            echo "$PROJNAME is already a project"
            return 1
        fi
    fi

    echo "$PROJNAME:$(pwd)" >> ~/.projecthist
    return 0
}

#
# Find the directory for a project from its name. Just returns the first path
# to a directory with the same name as the project.
#
function dir_for_project() {
    local PROJNAME=$1
    local PROJDIR

    #
    # Find project in project directory
    #
    if [[ -f ~/.projecthist ]]; then
        PROJDIR=$(grep "^$PROJNAME:" ~/.projecthist | head -1 | cut -d: -f2)
    fi

    echo "$PROJDIR"
}

#
# Find dir by traversing upwards
#
function reverse_find_dir() {
    local dir_to_find=$1
    local start_path=`pwd`    # Remember where we started so we can reset

	while [[ "`pwd`" != "/" ]];
	do
		if [ -d ".git" ]; then
			local found_git=1
			break
		fi
		cd ..
	done

	if [[ -n "$found_git" ]]; then
        pwd
	fi

    cd $start_path  # Reset cwd to where we started.
}

#
# cd to root of current git working dir
#
function cd_git_root() {
    local root=`reverse_find_dir .git`
    if [[ -n "$root" ]]; then
        cd $root
    else
        echo "Could not find a .git dir"
    fi
}


# {{{ Python Stuff
#
# Source install another python package into the current python environment.
#
function srcinst() {
    local PROJNAME=$1
    local PROJDIR=$(dir_for_project $PROJNAME)

    echo "Uninstalling existing..."
    pip freeze | grep -i "$PROJNAME" &> /dev/null
    if [ $? = 0 ]; then
        pip uninstall $PROJNAME
    fi

    echo "Installing from $PROJDIR..."
    pushd $PROJDIR
    pip install -e .
    popd
}

#
# Check if we have an active python.
#
function is_python_active() {
    if [[ $(type -w deactivate) == "deactivate: function" ]]; then
        return 0
    fi

    return 1
}

function find_python_venv_activate_script() {
    local curr_dir=$1
    [[ -z $1 ]] && curr_dir=.

    local probe

    # unix style activation available?
    probe="$curr_dir/venv/bin/activate"
    if [[ -f $probe ]]; then
        echo $probe
        return 0
    fi

    # windows style activation available?
    probe="$curr_dir/venv/Scripts/activate"
    if [[ -f $probe ]]; then
        echo $probe
        return 0
    fi

    # LIME embedded style activation available?
    probe="$curr_dir/Python34/Scripts/activate"
    if [[ -f $probe ]]; then
        echo $probe
        return 0
    fi
}

function dir_has_python_venv() {
    if [[ -n $(find_python_venv_activate_script) ]]; then
        return 0
    fi

    return 1
}

function activate_python() {
    local new_dir=$1
    [[ -z $1 ]] && new_dir=.

    local activate_script=`find_python_venv_activate_script $new_dir`

    if [ -z $activate_script ]; then
        return 1
    fi

    if is_python_active; then
        deactivate
        unset deactivate
    fi

    export VIRTUAL_ENV_DISABLE_PROMPT='1'
    source ${activate_script}
}

#
# Function for recursively find a venv in parent dirs and activate it
#
function av() {
    local start_path=`pwd`	# Remember where we started so we can reset

    while [[ "`pwd`" != "/" ]];
    do
        local activate_script=`find_python_venv_activate_script`
        if [ -n "$activate_script" ]; then
            activate_python
            local found_venv=1
            break
        fi
        cd ..
    done

    if [[ -z "$found_venv" ]]; then
        echo "Could not find a python to activate!"
    fi

    cd $start_path  # Reset cwd to where we started.
}

#
# Function to cd to a directory and automatically activate any
# Python virtual environment in the target dir.
#
function cd_venv() {
    cd $1 && activate_python
}


# }}}

# {{{ Tmux Stuff

#
# Start, or attach to, a tmux sesssion with a window for
# the desired project.
#

function _default_tmux_pane_layout() {
    local WORKDIR=$1
    echo "Setting up default layout. Directory: $WORKDIR"

    # tmux send-keys -t 0 'av; vim' C-m # vim with activated python
}


function tms() {
    local SESSIONNAME="LIME"
    local PROJNAME=$1
    local SHOWHELP
    local opt

    # Reset getopts
    OPTIND=1

    SHOWHELP=0

    while getopts ":la:" opt; do
        case "$opt" in
            l)
                cat ~/.projecthist
                return
                ;;
            a)
                _add_curr_dir_to_projects $OPTARG
                return
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                SHOWHELP=1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                SHOWHELP=1
                ;;
        esac
    done

    if [[ -z "$PROJNAME" ]]; then
        echo "No project name supplied!"
        SHOWHELP=1
    fi

    if [[ $SHOWHELP -eq 1 ]]; then
        echo "Manage tmux projects:"
        echo "-l\tList all registered projects"
        echo "-a <projname>\tAdd the current directory as project <projname>"
        echo ""
        echo "tms <projname>\tloads project in tmux"
        return 1
    fi

    local PROJDIR=$(dir_for_project $PROJNAME)
    if [ -z "$PROJDIR" ]; then
        echo "Could not find project $PROJNAME"
        return 1
    fi

    #
    # See if we already have a seesion. If not, create one
    #
    tmux has-session -t $SESSIONNAME &> /dev/null
    if [ $? != 0 ]; then
        echo "Session $SESSIONNAME not found. Creating it..."
        echo "Project name: $PROJNAME, Working dir: $PROJDIR"
        tmux new-session -s $SESSIONNAME -d -n $PROJNAME -c $PROJDIR
        _default_tmux_pane_layout $PROJDIR
    else
        echo "Session $SESSIONAME is running. Attaching..."
        #
        # Check if we already have a window for the project
        # If not, create a new window. Otherwise, select the exisiting one.
        tmux list-windows -t LIME | grep "^[[:digit:]]\+: $PROJNAME.\?[[:space:]]\+.*$" &> /dev/null
        if [ $? != 0 ]; then
            echo "$PROJNAME has no current window. Creating..."
            echo "Project name: $PROJNAME, Working dir: $PROJDIR"
            tmux new-window -n $PROJNAME -c $PROJDIR
            _default_tmux_pane_layout $PROJDIR
        else
            echo "$PROJNAME has an open window. Selecting it..."
            tmux select-window -t $PROJNAME
        fi
    fi

    #
    # Attach to the session. If this fails because we're already attached,
    # fail silently.
    #
    tmux attach-session -t $SESSIONNAME &> /dev/null
}

# }}}

# }}}

# {{{ Aliases

# {{{ General shell stuff
# Tell tmux to always expect 256 colors
alias tmux='tmux -2'

# attach to an exisiting tmux session
alias tma='tmux attach'

# Reload profile after making changes
alias zr!='echo "Reloading .zshrc..." && source ~/.zshrc'

# Quickly cd to root of current .git dir
alias cdg='cd_git_root'

# Make the cd command automatically activate venv
alias cd='cd_venv'

# }}}

# }}}

# {{{ Customized prompt
setopt PROMPT_SUBST

function venv_prompt_info() {
    if is_python_active; then
        local venv_path=`basename "$VIRTUAL_ENV/.."(:A)`
        echo "%{$fg_bold[yellow]%}[ $venv_path]%{$reset_color%}"
    fi
}

# {{{ Git status functions
ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# get the name of the branch we are on
function git_prompt_info() {
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
function parse_git_dirty() {
    local STATUS=''
    local FLAGS
    FLAGS=('--porcelain')

    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
        FLAGS+='--ignore-submodules=dirty'
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
        FLAGS+='--untracked-files=no'
    fi

    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)

    if [[ -n $STATUS ]]; then
        echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
        echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
}
# }}}

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local curr_time="%{$fg[green]%}%*"
local curr_dir="%{$reset_color%}%~"
local git_branch='%{$fg[blue]%}$(git_prompt_info)%{$reset_color%}'
local venv_info='$(venv_prompt_info)'

export PROMPT="%{$fg[blue]%}┌── ${curr_time} ${curr_dir} ${git_branch} ${venv_info}
%{$fg[blue]%}└─%{$reset_color%}$ "
export RPS1="${return_code}"
# }}}

# {{{ Load OS specific settings
if [[ -n $(uname | egrep -i 'darwin') ]]; then
    source ~/.zshrc.darwin
elif [[ -n $(uname | egrep -i 'cygwin') ]]; then
    source ~/.zshrc.cygwin
fi
# }}}
