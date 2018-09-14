SSH_ENV=$HOME/.ssh/environment

pullrepos() {
  start_repos;  # cd into the repositories folder
  
  shopt -s dotglob  # allows matches for directories beginning with .
  for directory in ./*; do  # for each folder in the repositories directory
    if [[ -d ${directory}/.git ]]; then # if this directory is a git repo
      echo ""
      echo "${directory}"
      echo ""
      cd "${directory}"
      gckm; # checkout master branch
      gpl;  # pull
      cd .. # go back to parent directory
    fi
  done
}


#starts git bash in $HOME/Documents/Repositories, where all git repos are stored
start_repos() {
  cd $HOME/Documents/Repositories
}


# ----------------------------------------------------------------------------
# Repositories
# ----------------------------------------------------------------------------

# personal AutoHotKey repo
ahk () {
  cd $HOME/Documents/Repositories/ahk
}

# crete-code master
ccm() {
  cd $HOME/Documents/Repositories/crete-code
  gckm
  gpl
}

# crete-code current branch
cc() {
  cd $HOME/Documents/Repositories/crete-code
}

# library master
libm() { 
  cd $HOME/Documents/Repositories/sawsoft-x3-library
  gckm
  gpl
}

# library current branch
lib() {
  cd $HOME/Documents/Repositories/sawsoft-x3-library
}

# CIS master
cism() {
  cd $HOME/Documents/Repositories/CIS
  gckm
  gpl
}

# CIS current branch
cis() {
  cd $HOME/Documents/Repositories/CIS
}

# estimating front-end master
efem() {
  cd $HOME/Documents/Repositories/est-front-end
  gckm
  gpl
}

# estimating front-end current branch
efe() {
  cd $HOME/Documents/Repositories/est-front-end
}

# estimating back-end master
ebem() {
  cd $HOME/Documents/Repositories/est-back-end
  gckm
  gpl
}

# estimating back-end current branch
ebe() {
  cd $HOME/Documents/Repositories/est-back-end
}

# translator master
transm() {
  cd $HOME/Documents/Repositories/translator
  gckm
  gpl
}

# translator current branch
trans() {
  cd $HOME/Documents/Repositories/translator
}

# field-reporting current branch
fr() {
  cd $HOME/Documents/Repositories/field-reporting
}

# field-reporting current master
frm() {
  cd $HOME/Documents/Repositories/field-reporting
  gckm
  gpl
}

# field-reporting current "develop"
frd() {
  cd $HOME/Documents/Repositories/field-reporting
  git checkout develop
  gpl
}

# uws (unity windows service) master
uwsm() {
  cd $HOME/Documents/Repositories/uws
  gckm
  gpl
}

# uws (unity windows service) current branch
uws() {
  cd $HOME/Documents/Repositories/uws
}

# unit test radiator master
utrm() {
  cd $HOME/Documents/Repositories/automated-test-radiator
  gckm
  gpl
}

# unit test radiator current branch
utr() {
  cd $HOME/Documents/Repositories/automated-test-radiator
}


# ----------------------------------------------------------------------------
# Git
# ----------------------------------------------------------------------------
#checkout master
gckm() {
  git checkout master 
}

# git merge $1
gm() {
  git merge "$1"
}

#git clone
gcl() {
  git clone "$1"
}

#pushes to current branch name -- used when pushing for the first time
gp() {
  git push --set-upstream origin "$(git branch | grep \* | cut -d ' ' -f2)"
}

#git push (after first)
gps() {
  git push
}

#git checkout
gck() {
  git checkout
}

#make new branch
gckb() {
  git checkout -b
}

#git status
gst() {
  git status 
}

#add
ga() {
  git add 
}

#add all tracked
gaa() {
  git add . 
}

#commit with message flag
gco() {
  git commit -m 
}

gca() {
  gaa && git commit -m
}

#pull
gpl() {
  git pull 
}

#add all tracked and commit with message flag (one commit message)
gca() {
  git commit -a -m 
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

# deletes branch passed in as argument -- gdb branchName
gdb() {
  git branch -D "$1"
}

# display the entire log for the branch, unless you pass something after it
gl() {
  git log "$1"
}

# display the last commit message
gll() {
  git log -1
}


# ----------------------------------------------------------------------------
# Angular

# ----------------------------------------------------------------------------
# runs angular server
ngs() {
  ng serve
}

# runs angular tests with watch false if called 'ngt false', otherwise, runs tests in watch mode
ngt() {
  if [ "$1" = "false" ];
    then 
      ng test --watch=false
  fi

  if [ -z "$1" ];
    then
      ng test
  fi
}


# ----------------------------------------------------------------------------
# .NET
# ----------------------------------------------------------------------------
db() {
  dotnet build
}

drt() {
  dotnet restore
}

dr() {
  dotnet run
}

dc() {
  dotnet clean
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