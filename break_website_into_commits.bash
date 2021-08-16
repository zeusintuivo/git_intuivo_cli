#!/usr/bin/env bash
#
# break_website_into_commits.bash
#
#
# - - -  struct_testing, journal_get_sed_functions no sudo - - -  START
#
#
# DEBUG=1
set -E -o functrace
export THISSCRIPT
typeset -r THISSCRIPT="$0"
(( DEBUG ))  && echo "${THISSCRIPT}"
export THISFOLDER
typeset -r THISFOLDER="$(dirname "$0")"
(( DEBUG ))  && echo "${THISFOLDER}"

 export CPU_COUNT
  typeset -ri CPU_COUNT=1
if ( command -v nproc >/dev/null 2>&1; ) ; then
{
  CPU_COUNT="$(nproc)"
}
fi
 (( DEBUG ))  && echo "${CPU_COUNT}"
export THISSCRIPTCOMPLETEPATH
typeset -r THISSCRIPTCOMPLETEPATH="$(basename "$0")"   # § This goes in the FATHER-MOTHER script
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
# - - -  struct_testing, journal_get_sed_functions no sudo - - -  END
#
#
function check_required_packages(){
	local _packager="${1}"
  (( DEBUG )) && echo "1:${1}"      # param order    varname       varvalue               sample_value
  enforce_parameter_with_value      1               _packager        "${_packager}"         "pnpm"
  local packages="${@:2}"
  (( DEBUG )) && echo "2*@*:${@:2}" # param order    varname       varvalue               sample_value
  enforce_parameter_with_value      2               packages        "${packages}"         "ava dotenv"
  local package
  local current_package
  for package in ${packages} ; do
  {
    if  [[ -n "${package}" ]] && [ ! -e "${package}" ] ; then
    {
      current_package=$("${_packager}"  list "${package}" |  grep "${package}")
      if  [[ -n "${current_package}" ]] && [[ "${current_package}" == *"${package}"* ]] ; then
      {
        echo "/ "${_packager}"  ${package} installed"
      }
      else
      {
        echo "MISSING PACKAGE ${package}"
        exit 1
      }
      fi
    }
    fi
  }
  done
} # end check_required_packages
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
function _copy_dev_make_public_to_valet_link(){
	# Passes ... copies dev.sh into folder and creates valet
	local TARGETFOLDER="${1}" #   param order    varname         varvalue           sample_value
  (( DEBUG )) && Message "1:${1}"
  enforce_parameter_with_value      1           TARGETFOLDER   "${TARGETFOLDER}"   "/home/piotr/_/work/projects-web/breakage/"
	local _comments="${*:2}"  #   param order    varname         varvalue           sample_value
  (( DEBUG )) && Message "2**:${*:2}"
  enforce_parameter_with_value      2**         _comments      "${_comments}"      "correct folder"
	local LIGHTGREEN="\033[38;5;83m"
	local LIGHTPINK="\033[1;204m"
	local LIGHTYELLOW="\033[38;5;227m"
	local RESET="\033[0m"
	local CERO="\033[01;0m"
	local _current_folder_number=""
	echo -e "${LIGHTGREEN} ✔ ${LIGHTPINK} ${_comments}  ${RESET}"
	Message current folder $(pwd)
	if [ -d ./packages/core ] ; then
	{
		directory_exists_with_spaces "${TARGETFOLDER}/dev_lerna.sh"
	  [ ! -f ./dev.sh ] && cp "${TARGETFOLDER}/dev_lerna.sh" ./dev.sh
	  cd ./packages/core
	  mkdir -p public
	  cd ./public
	  _current_folder_number="$(echo "$(cut -d'-' -f1 <<<"$(basename $(pwd))")")"
	  valet link "${_current_folder_number}"
	  valet secure "${_current_folder_number}"
	  cd ..  # pwd/packages/core/public
	  cd ..  # pwd/packages/core
	  cd ..  # pwd/packages
	         # pwd/
	}
	else
	{
		directory_exists_with_spaces "${TARGETFOLDER}/dev.sh"
	  [ ! -f ./dev.sh ] && cp "${TARGETFOLDER}/dev.sh" ./dev.sh
	  mkdir -p public
	  cd ./public
	  _current_folder_number="$(echo "$(cut -d'-' -f1 <<<"$(basename $(pwd))")")"
	  valet link "${_current_folder_number}"
	  valet secure "${_current_folder_number}"
	  cd .. # pwd/public
	        # pwd/
	}
	fi

	# [ -f ./dev.sh ] && BUILDONLY=1 REMOVECACHE=1 ./dev.sh
  Message after valet folder $(pwd)
	pwd

} # end _copy_dev_make_public_to_valet_link
function log() {
  # Sample usage:
  #
  # (log "${TARGETLOGFILE}" INFO _no_wall_ "${_no_wall_broadcast_no_banner}" 2>&1) | tee -a "${_log_path}"
  # (log "${TARGETLOGFILE}" DEBUG _log_file "${_log_file}" 2>&1) | tee -a "${_log_path}"
  # (log "${TARGETLOGFILE}" WARN _log_path "${_log_path}" 2>&1) | tee -a "${_log_path}"
  # (log "${TARGETLOGFILE}" ERROR _____home "${HOME}" 2>&1) | tee -a "${_log_path}"
  # (log "${TARGETLOGFILE}" FATAL sudo_user "${SUDO_USER}" 2>&1) | tee -a "${_log_path}"
  # (log "${TARGETLOGFILE}" _FAILED_ CP) | tee -a "${_log_path}"
  #
  local TARGETLOGFILE="${1}"     # param order   varname       varvalue           sample_value
  (( DEBUG )) && echo "1:${1}"   # param order   varname       varvalue           sample_value
  enforce_parameter_with_value   1               TARGETLOGFILE "${TARGETLOGFILE}"  "/home/elle/_/work/projects-web/breakage/log.log"
  local type_of_msg="${2}"       # param order   varname       varvalue           enforced_options
  (( DEBUG )) && echo "2:${2}"   # param order   varname       varvalue           enforced_options
  enforce_parameter_with_options 2               type_of_msg   "${type_of_msg}"   "INFO DEBUG WARN ERROR FATAL _FAILED_"
  local msg="${*:3}"             # param order   varname       varvalue           sample_value
  (( DEBUG )) && echo "3:${*:3}" # param order   varname       varvalue           sample_value
  enforce_parameter_with_value   3               msg           "${msg}"           "this is msg for the log"
  [[ "${type_of_msg}" == "INFO" ]] && type_of_msg="INFO " # one space for aligning
  [[ "${type_of_msg}" == "WARN" ]] && type_of_msg="WARN " # as well
  local _composed="$(echo " [${type_of_msg}] $(date "+%Y.%m.%d-%H:%M:%S %Z")[$$] ${msg}")"
  # output if terminal is available
	test -t 1 && echo "${_composed}"
  if it_exists_with_spaces "${TARGETLOGFILE}" ; then
	{
		echo "${_composed}" >> "${TARGETLOGFILE}"
	}
	else
	{
		echo "${_composed}" > "${TARGETLOGFILE}"
	}
  fi
} # end log
function _breakable_copy_directory(){
  # _breakable_copy_directory  "${_cwd}" "${_current_commit}" "${_commit}"  "${_new_folder_name}" "${BASEFOLDER}" "${TARGETFOLDER}"
	# echo "in:${*}"
	# DEBUG=1
	local _cwd="${1}"
  (( DEBUG )) && echo "1:${1}" # param order    varname       varvalue               sample_value
  enforce_parameter_with_value      1        _cwd             "${_cwd}"              "/home/user/_/work/"
	local _commit_number="${2}"
  (( DEBUG )) && echo "2:${2}" # param order    varname       varvalue               sample_value
  enforce_parameter_with_value      2        _commit_number   "${_commit_number}"    "291"
	local _commit="${3}"
  (( DEBUG )) && echo "3:${3}" # param order    varname       varvalue               sample_value
  enforce_parameter_with_value      3        _commit          "${_commit}"           "304b6dcc9606fffdf79e959d72b5a3b3a1bf4e4"
	local _new_folder_name="${4}"
  (( DEBUG )) && echo "4:${4}" # param order    varname       varvalue               sample_value
  enforce_parameter_with_value      4        _new_folder_name "${_new_folder_name}"  "1234-304b6dcc-fixed-tool-20200405TZ1000"
	local _from="${5}"
  (( DEBUG )) && echo "5:${5}" # param order    varname       varvalue               sample_value
  enforce_parameter_with_value      5        _from            "${_from}"             "/home/pedro/_/workwitgit/"
	local _to="${6}"
  (( DEBUG )) && echo "6:${6}" # param order    varname       varvalue               sample_value
  enforce_parameter_with_value      6        _to              "${_to}"               "/home/mario/_/breakage/"
	local _packager="${7}"
  (( DEBUG )) && echo "7:${7}" # param order    varname       varvalue               sample_value
  enforce_parameter_with_value      7        _packager        "${_packager}"         "yarn"
  #
	local _target="${_to}/${_new_folder_name}"
  (( DEBUG )) && echo "_target:${_target}"
  enforce_variable_with_value _target "${_target}"
	local _date="$(cut -d- -f4- <<<"${_new_folder_name}")"
  (( DEBUG )) && echo "_date:${_date}"
  enforce_variable_with_value _date "${_date}"
  Checking "_date :${_date}:"
	local -i _err=0
	local _log_path="${_to}/breakage.log"
  (( DEBUG )) && echo "_log_path:${_log_path}"
  enforce_variable_with_value _log_path "${_log_path}"
	cd "${_from}"
	local _checked_out="$(/usr/bin/git checkout "${_commit}" 2>&1)"
	/usr/bin/git log -1 --oneline > COMMIT
	_err=$?
	local _last_commit="$(<COMMIT)"
	enforce_variable_with_value _last_commit "${_last_commit}"
	local _last_lower="$(to_lowercase "${_last_commit}")"
	Checking "_breakable_copy_directory _last_lower :${_last_lower}:$?"
	# exit 0
	enforce_variable_with_value _last_lower "${_last_lower}"
	if [[ "${_last_lower}" == *"build(deps)"* ]]  || \
		[[ "${_last_lower}" == *"dependabot"* ]] || \
		[[ "${_last_lower}" == *"cleanup"* ]] || \
		[[ "${_last_lower}" == *"bump"* ]] || \
		( [[ "${_last_lower}" == *"deps"* ]] && [[ "${_last_lower}" == *"bump"* ]] ) || \
		( [[ "${_last_lower}" == *"deps"* ]] && [[ "${_last_lower}" == *"build"* ]] )  \
   ; then
	{
		Skipping "build(deps) dependabot commit from bot"
		return 0
	}
	fi

  [ $_err -eq 0 ] && log "${_log_path}" "INFO" "${_last_commit}"
	# local _again_folder_name="$(get_commit_message "${_commit_number}" "${_commit}")"
	local _again_folder_name="$(echo -n "${_last_lower}" | \
		sed 's/merge pull request #....//g'  | \
		sed 's/ from//g' | \
		sed 's/ fix//g' | \
		sed 's/ add//g' | \
		sed 's/ branch//g' | \
		sed 's/branch//g' | \
		sed 's/adding//g' | \
		sed 's/ cleanup//g' | \
		sed 's/cleanup//g' | \
		sed 's/ feat//g' | \
		sed 's/ improve//g' | \
		convert_to_underdash)"
	# local _again_folder_name="$(only_7_dashed_words<<<"${_last_commit}")"
	Message "_again_folder_name:${_again_folder_name}"
	enforce_variable_with_value _again_folder_name "${_again_folder_name}"
	log "${_log_path}" "INFO" "Commit number:${_commit_number}"
	Message "_target:${_target}"
  # return 0
	if it_exists_with_spaces "${_target}" ; then
	{
		Message removing before making a fresh copy
		rm -rf "${_target}"
		wait
	}
	fi
	directory_does_not_exist_with_spaces "${_target}"
	Message "commit #:${_commit_number} ${_new_folder_name}"
	Message cp -R "${_from}" "${_target}"
	cp -R "${_from}" "${_target}"
	_err=$?
	[ $_err -gt 0 ] && touch "${_new_folder_name}._FAILED_.CP" && return 1
	[ $_err -gt 0 ] && log "${_log_path}" "_FAILED_" "CP" && return 1
	wait
	directory_exists_with_spaces "${_target}"
	directory_exists_with_spaces "${_target}/.git"
	cd "${_target}"
	_err=$?
	[ $_err -gt 0 ] && touch "${_new_folder_name}._FAILED_.CD" && return 1
	[ $_err -gt 0 ] && log "${_log_path}" "_FAILED_" "CD" && return 1
	if [[ "$(pwd)"	== "${_target}" ]] ; then
	{
		# _copy_dev_make_public_to_valet_link "${TARGETFOLDER}"  correct folder
		Message "${TARGETFOLDER}"  correct folder
	}
	else
	{
		touch "${_new_folder_name}_NOT_SAME_.FAILED_.CD"
		return 1
	}
	fi

	# _err=$?
	# [  $_err -gt 0 ] && touch "${_new_folder_name}._FAILED_.CHEKOUT" && return 1
	# [ $_err -gt 0 ] && log "${_log_path}" "_FAILED_" "CHEKOUT" && return 1
	#

	Message removing 1 rm -rf "${_target}/.git"
	rm -rf "${_target}/.git"
	_err=$?
	[  $_err -gt 0 ] && touch "${_new_folder_name}._FAILED_.RM" && return 1
	[ $_err -gt 0 ] && log "${_log_path}" "_FAILED_" "RM" && return 1
	Message $BASHLINENO $(pwd)
	Message linking ln -s ../../node_modules node_modules
	ln -s ../../node_modules node_modules
	Message linking ln -s ../../vendor vendor
	ln -s ../../vendor vendor
	# if ("${_packager}" install 2>&1) ; then
	# {
	# 	_err=$?
	# 	wait
	# }
  #  fi
  #  _err=$?
  #  wait
	# 	[ $_err -gt 0 ] && touch "${_new_folder_name}._FAILED_.INSTALL"
	# 	[ $_err -gt 0 ] && log "${_log_path}" "_FAILED_" "INSTALL"
	# 	[ $_err -gt 0 ] && mv "${_target}" "${_target}.COULD_NOT_INSTALL"
	#
	#("${_packager}" test && _err=$? || _err=$?) >/dev/null 2>&1
	# "${_packager}" test
	# _err=$?
  #  [ $_err -gt 0 ] && touch "${_new_folder_name}._FAILED_.TEST"
  #  [ $_err -gt 0 ] && log "${_log_path}" "_FAILED_" "TEST"
  # Patchy thingy here
  # second attempt to get the of the folder right when the folder name defaults to :123---- like this
  if it_exists_with_spaces "${_to}/${_commit_number}_${_again_folder_name}_${_date}" ; then
	{
		Message rm -rf "${_to}/${_commit_number}_${_again_folder_name}_${_date}"
		rm -rf "${_to}/${_commit_number}_${_again_folder_name}_${_date}"
	}
	fi
	Message Moving 1 mv ${LIGHTYELLOW}"${_target}" ${CYAN}to${LIGHTYELLOW} "${_to}/${_commit_number}_${_again_folder_name}_${_date}"
	mv "${_target}"  "${_to}/${_commit_number}_${_again_folder_name}_${_date}"
	# _err=$?
	# [ $_err -gt 0 ] && touch "${_new_folder_name}._FAILED_.MVSECONDATTEMPT" && return 1
	# [ $_err -gt 0 ] && log "${_log_path}" "_FAILED_" "MVSECONDATTEMPT" && return 1
  # echo $_err &&   exit 0
  du -cksh * > breakable_sizes.log
	return 0
} # end _breakable_copy_directory


# Thought
# 1. All commits
# 2. Loop
# 3. cp -R
function _one_liner(){                    # grep tab char       # delete_empty_lines
	echo "$(cat "${1}/breakage_sizes.log" | grep -P '\t'"${2}_")" |  sed '/^\s*$/d' >>"${1}/breakage_sizes_sorted.log"
} # end _one_liner

function _break_all_commits(){
	local _cwd=$(pwd)
	enforce_variable_with_value _cwd "${_cwd}"
	local BASEFOLDER="${1}"   #    param order    varname        varvalue           sample_value
  (( DEBUG )) && Message "1:${1}"
  enforce_parameter_with_value      1           BASEFOLDER     "${BASEFOLDER}"     "/home/peter/_/work/projects-web/website"
  #
  local TARGETFOLDER="${2}" #   param order    varname         varvalue           sample_value
  (( DEBUG )) && Message "2:${2}"
  enforce_parameter_with_value      2           TARGETFOLDER   "${TARGETFOLDER}"   "/home/pizze/_/work/projects-web/breakage/"
  #
  local PACKAGER="${3}"     #   param order    varname         varvalue           sample_value
  (( DEBUG )) && Message "3:${3}"
  enforce_parameter_with_value      3           PACKAGER       "${PACKAGER}"       "yarn"
  #
	BASEFOLDER="$(_normalize_path_name "${BASEFOLDER}")"
	enforce_variable_with_value BASEFOLDER "${BASEFOLDER}"
	directory_exists_with_spaces "${BASEFOLDER}"
	directory_exists_with_spaces "${BASEFOLDER}/.git"
	#
	TARGETFOLDER="$(_normalize_path_name "${TARGETFOLDER}")"
	enforce_variable_with_value TARGETFOLDER "${TARGETFOLDER}"
	directory_exists_with_spaces "${TARGETFOLDER}"
	#
  cd "${BASEFOLDER}"
  (( DEBUG )) && pwd
  # (( DEBUG )) && exit 0
	local _commits="$(_all_commits)"
	[ $? -gt 0 ] && failed to get all commits
	enforce_variable_with_value _commits "${_commits}"
	#
	# DEBUG=1
	#
	local -i _total_commits="$(echo "${_commits}" | wc -l)"
	enforce_variable_with_value _total_commits "${_total_commits}"
	(( DEBUG )) && Message "_total_commits:${_total_commits}"
	local -i _current_commit=$(( _total_commits ))
	enforce_variable_with_value _current_commit "${_current_commit}"
	(( DEBUG )) && Message "_current_commit:${_current_commit}"
	local _log_path="${_to}/breakage.log"
  (( DEBUG )) && echo "_log_path:${_log_path}"
  enforce_variable_with_value _log_path "${_log_path}"
	if it_exists_with_spaces "${_log_path}" ; then
	{
		rm  "${_log_path}"
	}
	fi
	local _commit
	local -i _counter=1
	# cd "${_cwd}"
	local _new_folder_name=""
	local _commit_description=""
	local _last_description=""
	local _last_lower=""

	while read -r _commit ; do
	{
		Message trying "${_commit}"
		cd "${BASEFOLDER}"
    [[ -z "${_commit}" ]] && continue  # skip empties
    enforce_variable_with_value _commit "${_commit}"
  	# cd "${BASEFOLDER}"
  	_commit_description="$(get_commit_7_description "${_commit}")"
  	# enforce_variable_with_value _commit_description "${_commit_description}"
  	# NOTE: because we are going backwards from top to bottom
  	#       if the description is the same. Then I assume is the part of a group commit
  	#       so it will be ignored to be cloned
  	_new_folder_name="$(get_commit_message "${_current_commit}" "${_commit}")"
  	Checking "_new_folder_name: :${_new_folder_name}:"
  	enforce_variable_with_value _new_folder_name "${_new_folder_name}"
	  # echo "${_new_folder_name}" | parallel -j ${CPU_COUNT} echo {}
  	if ([[ -n "${_last_description}" ]] ) ; then
  	{
			_last_lower="$(to_lowercase "${_last_description}")"
	  	Checking " _last_lower :${_last_lower}:$?"
	  	enforce_variable_with_value _last_lower "${_last_lower}"
	  	# exit 0
  	}
    fi
  	if ([[ -n "${_last_description}" ]] ) &&
  		(
  			[[ "${_last_description}" == *"${_commit_description}"* ]] ||
  			[[ "${_last_lower}" == *"cleanup"* ]] ||
  			[[ "${_last_lower}" == *"readme"* ]] ||
  			[[ "${_last_lower}" == *"build(deps)"* ]] ||
  			[[ "${_last_lower}" == *"bdependabot"* ]] ||
  			[[ "${_last_lower}" == *"bump"* ]] ||
  			( [[ "${_last_lower}" == *"deps"* ]] && [[ "${_last_lower}" == *"bump"* ]] ) ||
  			( [[ "${_last_lower}" == *"deps"* ]] && [[ "${_last_lower}" == *"build"* ]] )
  		) ; then
  	{
  		Skipping "${_counter}_ 'bump, cleanup, build + deps, bump + deps, readme, dependabot, build(deps), repeated' commits with same description: <${_commit_description}>"
  	}
  	else
  	{
      (( DEBUG )) && Message "commit #:${_counter} ${_current_commit} ${_new_folder_name}"
      _breakable_copy_directory  "${_cwd}" "${_current_commit}" "${_commit}"  "${_new_folder_name}" "${BASEFOLDER}" "${TARGETFOLDER}" "${PACKAGER}"
    }
  	fi
    _last_description="${_commit_description}"
    _counter=$(( _counter + 1 ))
    _current_commit=$(( _current_commit - 1 ))
    # (( _counter == 40 )) && exit 0
  }
	done <<< "${_commits}"
  cd  "${TARGETFOLDER}"
  Checking "sizes into  breakage_sizes.log du -cksh * | tee -a breakage_sizes.log"
	du -cksh * | tee -a "${TARGETFOLDER}/breakage_sizes.log"
	local _one _result=""
	Message ordering sizes
	local filesizes="$(<"${TARGETFOLDER}/breakage_sizes.log")"
	# for _commit in ${_commits} ; do
	echo "">"${TARGETFOLDER}/breakage_sizes_sorted.log"
	while read -r _commit ; do
	{
		[[ -z "${_commit}" ]] && continue  # skip empties
		_one_liner "${TARGETFOLDER}" "${_current_commit}"
		_current_commit=$(( _current_commit - 1 ))
  }
	done <<< "${_commits}"
  # done
	echo "$(cat "${TARGETFOLDER}/breakage_sizes.log" | grep -P '\t'"total")" |  sed '/^\s*$/d' >>"${TARGETFOLDER}/breakage_sizes_sorted.log"
		return 0
} # end break_all_commits
# check_required_packages pnpm "
#   ava

# "
if [ -z ${1} ] ; then
{
echo "

  Breaks a git repo into several folders

                                Base Git folder                  Folder where breakage will go       installer
$0 /home/user/_/work/projects-web/website /home/user/_/work/projects-web/breakage/       yarn
$0 /home/user/_/work/client/rnd/project /home/zeus/_/work/client/rnd/project_breakage/   bundle

"
}
else
{
	# "${*}"
	_break_all_commits ${*}
}
fi
echo "🥦"
exit 0
