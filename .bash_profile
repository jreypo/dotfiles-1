# Make separately installed vim come first in path
export PATH=/c/src/vim/bin:$PATH

# Common bash operation aliases
alias ll="ls -lp --color=auto"
alias g="gvim"

#
# Function for recursively find a venv in parent dirs and activate it
#
function actvenv() {
	start_path=`pwd`	# Remember where we started so we can reset

	while [[ "`pwd`" != "/" ]];
	do
		echo "Searching in `pwd` for a venv..."
		if [ -f "venv/Scripts/activate" ]; then
			echo "found a venv. activating..."
			source venv/Scripts/activate
			local found_venv=1
			break
		fi
		cd ..
	done

	if [[ -z "$found_venv" ]]; then
		echo "Could not find a venv directory!"
	fi

	cd $start_path  # Reset cwd to where we started.
}

function watchtests() {
    echo "watching `pwd` for changes..."
    /c/src/limetng/setup/watch_tests.py
}

function _update_ps1 {
    local error_level=$?
    local curr_python=`which python`
    export PYTHONIOENCODING=utf-8
    export PS1="$(/c/Python33/python.exe ~/bash_prompt.py $error_level $curr_python 2> /dev/null)"
}

export PROMPT_COMMAND="_update_ps1"
