#!/usr/bin/env bash
#
#
load_struct_testing_wget(){
    local provider="$HOME/_/clis/execute_command_intuivo_cli/struct_testing"
    # shellcheck disable=SC1090
    [   -e "${provider}"  ] && source "${provider}" # && echo "Loaded locally"
    [ ! -e "${provider}"  ] && eval """$(wget --quiet --no-check-certificate  https://raw.githubusercontent.com/zeusintuivo/execute_command_intuivo_cli/master/struct_testing -O -  2>/dev/null )"""   # suppress only wget download messages, but keep wget output for variable
    ( ( ! command -v passed >/dev/null 2>&1; ) && echo -e "\n \n  ERROR! Loading struct_testing \n \n " && exit 69; )
} # end load_struct_testing_wget
load_struct_testing_wget

# enforce_variable_with_value USER_HOME "${USER_HOME}"
# enforce_variable_with_value SUDO_USER "${SUDO_USER}"

# enforce_variable_with_value THISSCRIPT "${THISSCRIPT}"
# enforce_variable_with_value THISFOLDER "${THISFOLDER}"
# enforce_variable_with_value THISSCRIPTCOMPLETEPATH "${THISSCRIPTCOMPLETEPATH}"

_breakable_copy_directory(){

	# echo "in:${*}"
	# DEBUG=1
	local _cwd="${1}"
  (( DEBUG )) && echo "1:${1}" # param order    varname       varvalue    sample_value
  enforce_parameter_with_value      1           _cwd          "${_cwd}"     "/home/salba/_/work/"
	local _commit_number="${2}"
  (( DEBUG )) && echo "2:${2}" # param order    varname       varvalue            sample_value
  enforce_parameter_with_value      2           _commit_number "${_commit_number}"  "291"
	local _commit="${3}"
  (( DEBUG )) && echo "3:${3}" # param order    varname       varvalue            sample_value
  enforce_parameter_with_value      3           _commit        "${_commit}"   "304b6dcc9606fffdf79e959d72b5a3b3a1bf4e4"
	local _new_folder_name="${4}"
  (( DEBUG )) && echo "4:${4}" # param order    varname       varvalue            sample_value
  enforce_parameter_with_value      4        _new_folder_name "${_new_folder_name}"   "1234-304b6dcc-fixed-tool-20200405TZ1000"
	local _from="${5}"
  (( DEBUG )) && echo "5:${5}" # param order    varname       varvalue            sample_value
  enforce_parameter_with_value      5        _from            "${_from}"   "/home/salba/_/workwitgit/"
	local _to="${6}"
  (( DEBUG )) && echo "6:${6}" # param order    varname       varvalue            sample_value
  enforce_parameter_with_value      6        _to            "${_to}"   "/home/salba/_/wheretoputclones/"
	local _target="${_to}/${_new_folder_name}"
  (( DEBUG )) && echo "_target:${_target}" # param order    varname       varvalue            sample_value
  enforce_variable_with_value _target "${_target}"
	local _err=0
	echo "_target:${_target}"
  return 0
	if it_exists_with_spaces "${_target}" ; then
	{
		rm -rf "${_target}"
	}
	fi
	directory_does_not_exist_with_spaces "${_target}"
	echo "commit #:${_commit_number} ${_new_folder_name}"

	cp -R "${_from}" "${_target}"
	[ $? -gt 0 ] && touch "${_new_folder_name}._FAILED_.CP" && return 1
	wait
	directory_exists_with_spaces "${_target}"
	directory_exists_with_spaces "${_target}/.git"
	cd "${_target}"
	[ $? -gt 0 ] && touch "${_new_folder_name}._FAILED_.CD" && return 1
	if [[ "$(pwd)"	== "${_target}" ]] ; then
	{
		pass correct folder
	}
	else
	{
		touch "${_new_folder_name}_NOT_SAME_.FAILED_.CD"
		return 1
	}
	fi
	/usr/bin/git checkout "${_commit}"
	[  $? -gt 0 ] && touch "${_new_folder_name}._FAILED_.CHEKOUT" && return 1

	rm -rf "${_target}/.git"
	[  $? -gt 0 ] && touch "${_new_folder_name}._FAILED_.RM" && return 1
	yarn
	err=$?
	[ $err -gt 0 ] && touch "${_new_folder_name}._FAILED_.BUILD" && return 1
	[ $err -gt 0 ] && mv "${_target}" "${_target}.COULD_NOT_BUILD" && return 1
	return 0
} # end copy_directory

echo "${@}"
_breakable_copy_directory "${@}"