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
  local found
  cd "${_curdir}"
  local _cwd="$(pwd)"

  while read -r one_item; do
  {
    if [ ! -z "${one_item}" ] ; then  # if not empty
    {
      one_action="${local_actions}"
      while :  # replace all {#} to $one_item value
      do
        one_action="${one_action/\{\#\}/$one_item}"  # replace value inside string substitution expresion bash
        found=$(echo -n "${one_action}" | grep "{#}")
	[ $? -eq 1 ] &&  break
      done
      action="${one_action}"
      echo "${action}"
      eval "${action}"
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


