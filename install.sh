#!/usr/bin/env bash
printf "\n"

TARGET_DIR="$HOME/.local/share/qutebrowser/userscripts"
SCRIPTS_NEW=()
SCRIPTS=()

# ─< Check if the given command exists silently >─────────────────────────────────────────
command-exists() {
  command -v "$@" >/dev/null 2>&1
}

# create the directory, if it doesn't exist
if [[ ! -d "${TARGET_DIR}" ]]; then
  mkdir -p "${TARGET_DIR}"
fi

get-diff() {
  local diff="diff -U 0 --color"
  [[ -e "$1" ]] && [[ -e "$2" ]] && $diff "$1" "$2"
}

install-scripts() {
  for file in bin/*; do
    target="${file#bin/}"
    SCRIPTS+=("$target")

    if [[ -e "$TARGET_DIR/$target" ]]; then
      if ! diff -q "$TARGET_DIR/$target" "$file" 2>/dev/null; then
        get-diff "$TARGET_DIR/$target" "$file"
      fi
    else
      SCRIPTS_NEW+=("$target")
    fi

    cp -f "$file" "$TARGET_DIR/$target"
  done
}

print-log() {
  # only print if SCRIPTS_NEW is non zero
  ((${#SCRIPTS_NEW[@]} <= 0)) || {
    echo "You have ${#SCRIPTS_NEW[@]} new scripts:"
    printf "%s\n" "${SCRIPTS_NEW[@]}"
  }

  echo "You have ${#SCRIPTS[@]} scripts installed in ${TARGET_DIR@Q}"
}

install-scripts
print-log
