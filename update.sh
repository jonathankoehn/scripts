#!/usr/local/bin/bash


CYAN='\033[0;36m'
STATUS=$CYAN
GREEN='\033[0;32m'
RED='\033[0;31m'
WARNING=$RED
ORANGE='\033[0;33m'
NORMAL='\033[0m'

declare -A colors
colors[status]=$CYAN
colors[warning]=$RED

function out(){
    if [ -n "$2" ]
	then
	    COLOR=${colors[$1]}
		TEXT=$2
    else
	    COLOR=${colors[status]}
		TEXT=$1
	fi
    echo -e "${COLOR}${TEXT}${NORMAL}"
 }


function update_clam() {
   out "updating clam db"
   freshclam -v
}
function update_homebrew() {
   out "updating homebrew"
   brew update
   out "upgrading homebrew"
   brew upgrade
}
function update_anaconda() {
   out "updating anaconda"
   conda update --all
 }
function update_pip() {
  out "upgrading pip"
  pip install --upgrade pip
  #pip2 install --upgrade pip


  list_outdated="$(pip list --outdated | cut -d' ' -f1 | sed '1,2d')"
  if [ -n $list_outdated ]
      then
  	    out "no modules to upgrade"
      else
  	    out "upgrading pip modules"
  fi
  for m in $list_outdated; do
    pip install --upgrade $m;
  done

  #list_outdated2="$(pip list --outdated | cut -d' ' -f1)"
  #for m in $list_outdated2; do
  #  pip install --upgrade $m;
  #done

  list_outdated_after="$(pip list --outdated | cut -d' ' -f1 | sed '1,2d')"
  if [ ! -z "$list_outdated_after" ]; then
    out warning "not upgraded pip modules:"
    echo $list_outdated_after
  fi
}

out "$(tput bold)starting update script"
update_clam
update_homebrew
update_anaconda
#update_pip
out "$(tput bold)update script finished"
exit
