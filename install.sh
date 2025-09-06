#!/usr/bin/env bash
# install script for copying the needed files for the qute-rbw project.
# On default, this script makes sure the user has all the dependencies to run
# the add on right away. (after setting a hotkey for it)

DIR="${HOME}/.local/share/qutebrowser/userscripts"

check-afterwards() {
  local files=()
  files=(
    "$HOME/.local/share/qutebrowser/userscripts/qute-rbw"
    "$HOME/.local/share/qutebrowser/userscripts/qute-rbw-picker"
  )

  # check if the files were copied correctly.
  for f in "${files[@]}"; do
    if [[ ! -f "$f" ]]; then
      echo "Something went wrong while installing qute-rbw.."
      echo "$f is not be found.."
      exit 1
    fi
  done

  # if everything was found after exiting, then tell the user that installation
  # was successful.
  echo "qute-rbw was installed successfully!"
}
trap check-afterwards exit SIGINT INT

command-exists() {
  command -v "$@" >/dev/null 2>&1
}

check-deps() {
  local deps=() pkg needs

  deps=(
    "rbw"
    "qutebrowser"
    "kitty"
  )

  for pkg in "${deps[@]}"; do
    if ! command-exists "${pkg}"; then
      needs+=("${pkg}")
    fi
  done

  # if needs is not 0, then exit and inform the user
  ((${#needs[@]} <= 0)) || {
    echo "${#needs[@]} dependencies are missing (${needs[*]})"
    echo "Please install them, and come back later, or use the -s flag (or run 'make skip'), to skip the dependency check"
    exit 1
  }
}

get-diffs() {
  local lfile1 lfile2 file1 file2

  lfile1=./qute-rbw
  lfile2=./qute-rbw-picker

  file1="$DIR/qute-rbw"
  file2="$DIR/qute-rbw-picker"

  # return if no files are there in the first place
  [[ -f "${file1}" && -f "${file2}" ]] || return

  # if $look_for_diff; then
  diff1=$(diff "$file1" "$lfile1") # diff qute-rbw
  diff2=$(diff "$file2" "$lfile2") # diff qute-rbw-picker
  # fi

  ((${#diff1} <= 0)) || {
    echo "${fiel1#"${DIR}/"} got updated:"
    echo "${diff1}"
  }

  ((${#diff2} <= 0)) || {
    echo "${file2#"${DIR}/"} got updated:"
    echo "${diff2}"
  }
}

# check userscript dir and make sure the user executed the script in the right
# path (project root)
check-dirs() {
  if [[ ! -d "${DIR}" ]]; then
    mkdir -p "${DIR}"
    echo "$DIR was not present.. Created it for you."
  fi

  if [[ ! -f ./qute-rbw ]] || [[ ! -f ./qute-rbw-picker ]]; then
    echo "You are doing something really wrong!"
    echo "Go into the repo source, and use 'make' to install the qute-rbw userscript!"
    exit 1
  fi
}

# check the argument of the script.
# takes in arg as $1
# cheks only for '-s' or '--skip'
check-args() {
  local arg=$1

  [[ -n "${arg}" ]] || return
  if [[ "${arg}" =~ ^(-s|--skip) ]]; then
    skip=true
  fi
}

# make sure the files are executable and copy them over
make-qute-rbw() {
  local files=() file
  files=(
    "./qute-rbw-picker"
    "./qute-rbw"
  )

  for file in "${files[@]}"; do
    chmod +x "${file}" &&
      cp "${file}" "${DIR}/"
  done
}

# setting the skip flag do false by default
skip=false
arg=${1:-}

get-diffs # if updating, get the diff for local and installed files

# parse the script arguments
check-args "${arg}"

# default behaviour is to NOT SKIP check-deps(), only if '-s' or '--skip' is
# given, then skip the check-deps() process
if ! $skip; then
  check-deps
fi

if check-dirs; then
  make-qute-rbw
else
  echo "Something went terribly wrong"
fi
