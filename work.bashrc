SSH_ENV=$HOME/.ssh/environment

#starts git bash in $HOME/Documents/Repositories, where all git repos are stored
function start_repos {
  cd $HOME/Documents/Repositories;
}

# crete-code
function ccm {
  cd ~/Documents/Repositories/crete-code
  git checkout master
  git pull
}

function cc {
  cd ~/Documents/Repositories/crete-code
}

# library
function libm { 
  cd ~/Documents/Repositories/sawsoft-x3-library
  git checkout master
  git pull
}

function lib {
  cd ~/Documents/Repositories/sawsoft-x3-library
}

# CIS
function cism {
  cd ~/Documents/Repositories/CIS
  git checkout master
  git pull
}

function cis {
  cd ~/Documents/Repositories/CIS
}

# estimating front-end
function efem {
  cd ~/Documents/Repositories/est-front-end
  git checkout master
  git pull
}

function efe {
  cd ~/Documents/Repositories/est-front-end
}

# estimating back-end
function ebem {
  cd ~/Documents/Repositories/est-back-end
  git checkout master
  git pull
}

function ebe {
  cd ~/Documents/Repositories/est-back-end
}

# translator tool
function transm {
  cd ~/Documents/Repositories/translator
  git checkout master
  git pull
}

function trans {
  cd ~/Documents/Repositories/translator
}

# uws (unity windows service)
function uwsm {
  cd ~/Documents/Repositories/uws
  git checkout master
  git pull
}

function uws {
  cd ~/Documents/Repositories/uws
  git pull
}
# ----------------------------------------------------------------------------

#checkout master
function gckm {
  git checkout master 
}

#git clone - NOT WORKING: have to parse $1
function gcl {
  git clone $1
}

#pushes to current branch name -- used when pushing for the first time
function gp {
  git push --set-upstream origin "$(git branch | grep \* | cut -d ' ' -f2)"
}

#git push (after first)
function gps {
  git push
}

#git checkout
function gck {
  git checkout
}

#make new branch
function gckb {
  git checkout -b
}

#git status
function gst {
  git status 
}

#add
function ga {
  git add 
}

#add all tracked
function gaa {
  git add . 
}

#commit with message flag
function gco {
  git commit -m 
}

#pull
function gpl {
  git pull 
}

#add all tracked and commit with message flag (one commit message)
function gca {
  git commit -a -m 
}

function gsh {
  git stash 
}

function gpp {
  git pop 
}

function gd {
  git diff 
}

# deletes branch passed in as argument -- gdb repoName
function gdb() {
  git branch -D "$1"
}

# runs angular server
function ngs {
  ng serve
}

# runs angular tests with watch false if called 'ngt false', otherwise, runs tests in watch mode
function ngt() {
  if [ "$1" = "false" ];
    then 
      ng test --watch=false
  fi

  if [ -z "$1" ];
    then
      ng test
  fi
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
   start_repos;
   . "${SSH_ENV}" > /dev/null
   ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
       start_agent;
   }
else
    start_repos;
    start_agent;
fi



###
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