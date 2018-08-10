#!/bin/bash

. ~/Documents/Repositories/ahk/.bashrc

cd $HOME/Documents/Repositories;
# ----------------------------------------------------------------------------

#checkout master
gckm() {
  git checkout master 
}

#git clone
gcl() {
	git clone "$1"
}

#pushes to current branch name -- used when pushing for the first time
gpf() {
  git push --set-upstream origin "$(git branch | grep \* | cut -d ' ' -f2)"
}

#git push for first time
gp() {
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