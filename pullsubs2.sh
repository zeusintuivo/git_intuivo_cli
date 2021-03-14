#!/usr/bin/env bash

.dirs() {
    find * -maxdepth 0 -type d   # mac and linux tested
}
# DEBUG=1
# REMOVECACHE=1
.subdir() {
  # Perform all actions in
  #        LIST1
  #          for each element in
  #                           LIST2

  local _curdir="${1}"
  local ACTIONS="${2}"
  local local_items="$(.dirs)"
  local one_item
  local one_action
  local action
  local _cwd="$(pwd)"

  while read -r one_item; do
  {
    if [ ! -z "${one_item}" ] ; then  # if not empty
    {
      action="${ACTIONS/\{\#\}/$one_item}"  # replace value inside string substitution expresion bash
      eval ${action}
    }
    fi
  }
  done <<< "${local_items}"
}


CURDIR="${PWD}"

ACTIONS="echo -e \".\"
echo \" \"
echo \"Directory:\"
echo \". \"
echo \". . . . . . .       {#} \"
cd \"${CURDIR}/{#}\"
pwd
[[ -d .git/ ]] && pull
"
ACTIONS="
      cd \"${_cwd}/${#}\"
      pwd
      [[ -d .git/ ]] && pull
      if [[ ! -d .git/ ]] ; then
      {
        .subdir \"${_cwd}/${#}\" "${ACTIONS}"
      }
      fi
"
.subdir  "${CURDIR}" "${ACTIONS}" 

