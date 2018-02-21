#!/bin/bash

declare -x SSH_ENV="$HOME/.ssh/environment"

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
   . "${SSH_ENV}" > /dev/null
   ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
       start_agent;
   }
else
    start_agent;
fi


if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion                                                                                                                                                                
fi

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

for al in `__git_aliases`; do
    alias g$al="git $al"
    
    complete_func=_git_$(__git_aliased_command $al)
    function_exists $complete_fnc && __git_complete g$al $complete_func
done

