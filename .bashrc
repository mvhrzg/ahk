declare -x SSH_ENV="$HOME/.ssh/environment"

#starts git bash in $HOME/Documents/Repositories, where all git repos are stored
repos() {
  cd $HOME/Documents/Repositories;
}

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
   repos;
   . "${SSH_ENV}" > /dev/null
   ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
       start_agent;
   }
else
    repos;
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

# ----------------------------------------------------------------------------

#checkout master
gckm() {
  git checkout master 
}

#git clone - NOT WORKING: have to parse $1
gcl() {
	git clone "$1"
}

#pushes to current branch name -- used when pushing for the first time
gpf() {
  git push --set-upstream origin "$(git branch | grep \* | cut -d ' ' -f2)"
}

#git push (after first)
gps() {
  git push
}

#git checkout
gck() {
  git checkout  "$1"
}

#make new branch
gckb() {
  git checkout -b "$1"
}

#git status
gst() {
  git status 
}

#add
ga() {
  git add "$1"
}

#add all tracked
gaa() {
  git add . 
}

#commit with message flag
gco() {
  git commit -m "$1"
}

#pull
gpl() {
  git pull
}

#add all tracked and commit with message flag (one commit message)
gca() {
  git commit -a -m "$1"
}

gsh() {
  git stash 
}

gpp() {
  git pop 
}

gd() {
  git diff 
}

# deletes branch passed in as argument -- gdb repoName
gdb() {
  git branch -D "$1"
}

ahk() {
	cd $HOME/Documents/Repositories/ahk
	gst
	gpl
}

hr() {
	cd $HOME/Documents/Repositories/hackerrank
	gst
	gpl
}



rupd() {
	HOMEDIR=$HOME"/Documents/Repositories"
	DIRS=`ls -l $HOMEDIR | egrep '^d' | awk '{print $9}'`
	for DIR in $DIRS
	do
		echo "~/Documents/Repositories/${DIR%?}"
		cd ${HOMEDIR}/${DIR}
		gst
		echo "Pulling..."
		gpl
		cd ..
	done
}