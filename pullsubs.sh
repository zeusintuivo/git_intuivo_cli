#!/usr/bin/env bash

.dirs() {
    find * -maxdepth 0 -type d   # mac and linux tested
}
# DEBUG=1
# REMOVECACHE=1
.pullsubdirs() {
  # Perform all actions in
  #        LIST1
  #          for each element in
  #                           LIST2

  local _curdir="${1}"
  local _subdir=""
  local local_actions="${2}"
  local local_items="$(.dirs)"
  local one_item
  local one_action
  local action
  # local _subdirs
  local _actions
  cd "${_curdir}"
  local _cwd="$(pwd)"

  while read -r one_item; do
  {
    if [ ! -z "${one_item}" ] ; then  # if not empty
    {
      action="${one_actions/\{\#\}/$one_item}"  # replace value inside string substitution expresion bash
      echo "${action}"
        _subdir="${_cwd}/${one_item}"
      cd "${_subdir}"
      pwd
      [[ -d .git/ ]] && pull
      if [[ ! -d .git/ ]] ; then
      {
        _actions="echo -e \".\"
        echo \" \"
        echo \"Subdirectory:\"
        echo \". \"
        echo \". . . . . . .       {#} \"
        cd \"${_subdir}/{#}\"
        pwd
        [[ -d .git/ ]] && pull
        "
        .pullsubdirs "${_subdir}" "${_actions}"
      }
      fi
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

.pullsubdirs  "${CURDIR}" "${ACTIONS}" 


