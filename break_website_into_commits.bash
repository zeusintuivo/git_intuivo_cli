#!/usr/bin/env bash
#
#
# - - -  struct_testing no sudo - - -  START
#
#
# DEBUG=1
export THISSCRIPT
typeset -gr THISSCRIPT="$0"
(( DEBUG ))  && echo "${THISSCRIPT}"
export THISFOLDER
typeset -gr THISFOLDER="$(dirname "$0")"
(( DEBUG ))  && echo "${THISFOLDER}"

 export CPU_COUNT
  typeset -g CPU_COUNT=1
if ( command -v nproc >/dev/null 2>&1; ) ; then
{
  CPU_COUNT="$(nproc)"
}
fi
 (( DEBUG ))  && echo "${CPU_COUNT}"
export THISSCRIPTCOMPLETEPATH
typeset -gr THISSCRIPTCOMPLETEPATH="$(basename "$0")"   # § This goes in the FATHER-MOTHER script
export _err
typeset -i _err=0
export USER_HOME="$HOME"
export SUDO_USER="$USER"

load_struct_testing_wget(){
    local provider="$HOME/_/clis/execute_command_intuivo_cli/struct_testing"
    # shellcheck disable=SC1090
    [   -e "${provider}"  ] && source "${provider}" && echo "Loaded locally"
    [ ! -e "${provider}"  ] && eval """$(wget --quiet --no-check-certificate  https://raw.githubusercontent.com/zeusintuivo/execute_command_intuivo_cli/master/struct_testing -O -  2>/dev/null )"""   # suppress only wget download messages, but keep wget output for variable
    ( ( ! command -v passed >/dev/null 2>&1; ) && echo -e "\n \n  ERROR! Loading struct_testing \n \n " && exit 69; )
} # end load_struct_testing_wget
load_struct_testing_wget
load_journal_functions_wget(){
    local provider="$HOME/_/clis/journal_intuivo_cli/journal_get_sed_functions"
    # shellcheck disable=SC1090
    [   -e "${provider}"  ] && source "${provider}" && echo "Loaded locally"
    [ ! -e "${provider}"  ] && eval """$(wget --quiet --no-check-certificate  https://raw.githubusercontent.com/zeusintuivo/journal_intuivo_cli/master/journal_get_sed_functions -O -  2>/dev/null )"""   # suppress only wget download messages, but keep wget output for variable
    ( ( ! command -v passed >/dev/null 2>&1; ) && echo -e "\n \n  ERROR! Loading journal_functions \n \n " && exit 69; )
} # end load_journal_functions_wget
load_journal_functions_wget
enforce_variable_with_value USER_HOME "${USER_HOME}"
enforce_variable_with_value SUDO_USER "${SUDO_USER}"

enforce_variable_with_value THISSCRIPT "${THISSCRIPT}"
enforce_variable_with_value THISFOLDER "${THISFOLDER}"
enforce_variable_with_value THISSCRIPTCOMPLETEPATH "${THISSCRIPTCOMPLETEPATH}"
#
#
# - - -  struct_testing no sudo - - -  END
#
#
function _normalize_path_name(){
	local _dirpart="$(dirname "${1}")"
	local _basepart="$(basename "${1}")"
	echo "${_dirpart}/${_basepart}"
} # end normalize_path_name

function _all_commits(){
  /usr/bin/git log --reflog | grep ^commit  --color=no | cuet "commit "
} # end all_commits

function get_commit_description(){
	local _commit_description="$(/usr/bin/git log "${1}" -1 --format=%s)"  # description of commit
	echo -n "${_commit_description}" |  only_3_dashed_words
} # end get_commit_description
function get_commit_7_description(){
	local _commit_description="$(/usr/bin/git log "${1}" -1 --format=%s)"  # description of commit
	echo -n "${_commit_description}" |  only_7_dashed_words
} # end get_commit_7_description
function get_commit_message(){
	local _counter="${1}"
	local _commit="${2}"
	# /usr/bin/git log "${_commit}" -1 --oneline    # entire commit
	local _commit_short_number="$(/usr/bin/git log "${_commit}" -1 --format=%h)"  # short commit name
	local _commit_description="$(get_commit_description "${_commit}" )"  # description of commit
	local _commit_date="$(TZ=UTC /usr/bin/git show "${_commit}" --quiet --date='format-local:%Y%m%dT%H%M%SZ' --format="%cd")"  # military date
  echo "${_counter}-${_commit_short_number}-${_commit_description}-${_commit_date}"
} # end get_commit_message


function _breakable_copy_directory(){
  # _breakable_copy_directory  "${_cwd}" "${_current_commit}" "${_commit}"  "${_new_folder_name}" "${BASEFOLDER}" "${TARGETFOLDER}"
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
  # return 0
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

	/usr/bin/git log -1 --oneline > COMMIT
	local _again_folder_name="$(get_commit_message "${_commit_number}" "${_commit}")"

	rm -rf "${_target}/.git"
	[  $? -gt 0 ] && touch "${_new_folder_name}._FAILED_.RM" && return 1
	yarn
	err=$?
	[ $err -gt 0 ] && touch "${_new_folder_name}._FAILED_.BUILD" && return 1
	[ $err -gt 0 ] && mv "${_target}" "${_target}.COULD_NOT_BUILD" && return 1

  if it_exists_with_spaces "${_to}/${_again_folder_name}" ; then
	{
		rm -rf "${_to}/${_again_folder_name}"
	}
	fi
	mv "${_target}"  "${_to}/${_again_folder_name}"
	return 0
} # end _breakable_copy_directory


# Thought
# 1. All commits
# 2. Loop
# 3. cp -R
function _break_all_commits(){
	local _cwd=$(pwd_)
	local BASEFOLDER="${1}"   #    param order    varname       varvalue           sample_value
  (( DEBUG )) && Message "1:${1}"
  enforce_parameter_with_value      1           BASEFOLDER    "${BASEFOLDER}"     "/home/salba/_/work/pixum/projects/pixum-web/website"
  #
  local TARGETFOLDER="${2}"  #   param order    varname       varvalue           sample_value
  (( DEBUG )) && Message "2:${2}"
  enforce_parameter_with_value      2          TARGETFOLDER   "${TARGETFOLDER}"   "/home/salba/_/work/pixum/projects/pixum-web/breakage/"

	BASEFOLDER="$(_normalize_path_name "${BASEFOLDER}")"
	directory_exists_with_spaces "${BASEFOLDER}"
	directory_exists_with_spaces "${BASEFOLDER}/.git"

	TARGETFOLDER="$(_normalize_path_name "${TARGETFOLDER}")"
	directory_exists_with_spaces "${TARGETFOLDER}"

  cd "${BASEFOLDER}"
  (( DEBUG )) && pwd
  # (( DEBUG )) && exit 0
	local _commits="$(_all_commits)"
	[ $? -gt 0 ] && failed to get all commits
	enforce_variable_with_value _commits "${_commits}"

	# DEBUG=1

	local -i _total_commits="$(echo "${_commits}" | wc -l)"
	(( DEBUG )) && Message "_total_commits:${_total_commits}"
	local -i _current_commit=$(( _total_commits ))
	(( DEBUG )) && Message "_current_commit:${_current_commit}"
	local _commit
	local -i _counter=1
	# cd "${_cwd}"
	local _new_folder_name=""
	local _commit_description=""
	local _last_description=""
	while read -r _commit ; do
	{
    if [[ -n "${_commit}" ]] ; then  # is not empty
    {
    	# cd "${BASEFOLDER}"
    	_commit_description="$(get_commit_7_description "${_commit}")"
    	# NOTE: because we are going backwards from top to bottom
    	#       if the description is the same. Then I assume is the part of a group commit
    	#       so it will be ignored to be cloned
    	_new_folder_name="$(get_commit_message "${_current_commit}" "${_commit}")"
  		echo "${_new_folder_name}" | parallel -j ${CPU_COUNT} echo {}

    	if [[ -n "${_last_description}" ]] && [[ "${_last_description}" == *"${_commit_description}"* ]] ; then
    	{
    		echo "  --skip ignoring repeated commit: <${_commit_description}>"
    	}
    	else
    	{
	      (( DEBUG )) && Message "commit #:${_counter} ${_current_commit} ${_new_folder_name}"
				# parallel -j 4  echo "${_new_folder_name}"
	      # if is_installed parallel ; then
	      # {
      	# cd "${_cwd}"
  			# echo "${_new_folder_name}" | parallel -j ${CPU_COUNT} /home/salba/_/work/pixum/projects/pixum-web/breakable_commit_copy_directory.bash  {}
        # echo "${_cwd}" "${_current_commit}" "${_commit}" "${_new_folder_name}" "${BASEFOLDER}"  "${TARGETFOLDER}"	| parallel -j ${CPU_COUNT}  _copy_directory -q """{}"""
        # echo "${_cwd}" "${_current_commit}" "${_commit}" "${_new_folder_name}" "${BASEFOLDER}"  "${TARGETFOLDER}"	| parallel -j ${CPU_COUNT}  /home/salba/_/work/pixum/projects/pixum-web/breakable_commit_copy_directory.bash {}
        # parallel -j ${CPU_COUNT}  /home/salba/_/work/pixum/projects/pixum-web/breakable_commit_copy_directory.bash    "${_cwd}" "${_current_commit}" "${_commit}"  "${_new_folder_name}" "${BASEFOLDER}" "${TARGETFOLDER}"
        # /home/salba/_/work/pixum/projects/pixum-web/breakable_commit_copy_directory.bash    "${_cwd}" "${_current_commit}" "${_commit}"  "${_new_folder_name}" "${BASEFOLDER}" "${TARGETFOLDER}"
        _breakable_copy_directory  "${_cwd}" "${_current_commit}" "${_commit}"  "${_new_folder_name}" "${BASEFOLDER}" "${TARGETFOLDER}"
        # echo parallel -j ${CPU_COUNT}  echo   "${_cwd}"
        # "${_current_commit}" "${_commit}"  "${_new_folder_name}" "${BASEFOLDER}" "${TARGETFOLDER}"
        # echo "${_cwd}" "${_current_commit}" "${_commit}" "${_new_folder_name}" "${BASEFOLDER}"  "${TARGETFOLDER}"	| parallel -j ${CPU_COUNT}  ./breakable_commit_copy_directory.bash -q """{}"""
        # echo "${_new_folder_name}"  | parallel -j 4 Message  -q {}
        # cat list.txt | parallel -j 4 wget -q {	}
        #  	# parallel -j 4 wget -q {}
        #  	echo parallel -j ${CPU_COUNT} _copy_directory "${_cwd}" "${_current_commit}" "${_commit}" "${_new_folder_name}" "${BASEFOLDER}"  "${TARGETFOLDER}"
        #  	parallel -j ${CPU_COUNT} echo "commit #:${_counter} ${_current_commit} ${_new_folder_name}"
    	# }
    	# else
    	# {
    		# Message "commit #:${_counter} ${_current_commit} ${_new_folder_name}"
    	  # 	echo "commit #:${_counter} ${_current_commit} ${_new_folder_name}"
        #  	echo _copy_directory "${_cwd}" "${_current_commit}" "${_commit}" "${_new_folder_name}" "${BASEFOLDER}"  "${TARGETFOLDER}"
    	# }
      # fi
    	}
    	fi
      _last_description="${_commit_description}"
      _counter=$(( _counter + 1 ))
      _current_commit=$(( _current_commit - 1 ))
      # (( _counter == 40 )) && exit 0
    }
  	fi
  }
	done <<< "${_commits}"
	return 0
} # end break_all_commits

_break_all_commits "/home/salba/_/work/pixum/projects/pixum-web/website" "/home/salba/_/work/pixum/projects/pixum-web/breakage/"


echo "🥦"
exit 0
