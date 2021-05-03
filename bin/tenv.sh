#!/usr/bin/env bash

TENV_VERSION="0.0.1"
TERMINAL_CONFIG_FILENAME=".terminal-config"
TERMINAL_INITZSH_FILENAME="libexec/tenv-init.zsh"
TERMINAL_INITBASH_FILENAME="libexec/tenv-init.bash"

# *** set **********************************************************************
getTargetDir() {
  echo -ne "$(pwd)"
}
findTerminalConfig() {
  local root="$1"
  while [ -n "$root" ]; do
    if [ -e "${root}/${TERMINAL_CONFIG_FILENAME}" ]; then
      echo -ne "${root}/${TERMINAL_CONFIG_FILENAME}"
    fi
    root="${root%/*}"
  done
}
identifyTerminal() {
  # - iTerm.app
  # - Apple_Terminal
  echo -ne "${TERM_PROGRAM}"
}
clearTerminalConfig() {
  local term="$1"
  if [ "${term}" = "iTerm.app" ]; then
    echo -ne "\033]50;SetProfile=\a"
    echo -ne "\033]6;1;bg;*;default\a"
    echo -ne "\033]0;\007"
    echo -ne "\033]1337;SetBadgeFormat=\007"
  fi
}
setTerminalConfig() {
  local term="$1"
  local conf="$2"
  if [ "${term}" = "iTerm.app" ]; then
    IFS="="
    while read -r k v; do
      case "${k}" in
        "ITERM2_PROFILE"   ) local profile="${v}" ;;
        "ITERM2_TAB_COLOR" ) local tabColor="${v}" ;;
        "ITERM2_TITLE"     ) local tabTitle="${v}" ;;
        "ITERM2_BADGE"     ) local badge="${v}" ;;
      esac
    done < "${conf}"

    # iTerm2 Profile
    if [ -n "${profile}" ]; then
      echo -ne "\033]50;SetProfile=${profile}\a"
    else
      echo -ne "\033]50;SetProfile=\a"
    fi
    # iTerm2 Tab color
    if [ -n "${tabColor}" ]; then
      local clr=`echo "ibase=16; ${tabColor}" | bc`
      echo -ne "\033]6;1;bg;red;brightness;$((clr / 256 / 256))\a";
      echo -ne "\033]6;1;bg;green;brightness;$((clr / 256 % 256))\a";
      echo -ne "\033]6;1;bg;blue;brightness;$((clr % 256))\a";
    else
      echo -ne "\033]6;1;bg;*;default\a"
    fi
    # iTerm2 Tab title
    if [ -n "${tabTitle}" ]; then
      echo -ne "\033]0;"${tabTitle}"\007"
    else
      echo -ne "\033]0;\007"
    fi
    # iTerm2 Badge
    if [ -n "${badge}" ]; then
      b=`echo "${badge}" | base64`; echo -ne "\033]1337;SetBadgeFormat=${b}\007"
    else
      echo -ne "\033]1337;SetBadgeFormat=\007"
    fi
  fi
}
setTenv() {
  terminal_name=`identifyTerminal`
  target_dir=`getTargetDir`
  terminal_config_file=`findTerminalConfig "${target_dir}"`
  if [ ! -e "${terminal_config_file}" ]; then clearTerminalConfig "${terminal_name}"; exit 1; fi

  setTerminalConfig "${terminal_name}" "${terminal_config_file}"
  exit 0;
}

# *** init *********************************************************************
resolveShell() {
  local shell="$(ps -p "$PPID" -o 'args=' 2>/dev/null || true)"
  local shell="${shell%% *}"
  local shell="${shell##-}"
  local shell="${shell:-$SHELL}"
  local shell="${shell##*/}"
  if [ "$shell" = "sh" ]; then
    local bashVer=$($(which sh) "--version" | grep "bash")
    if [ -n "${bashVer}" ]; then
      shell="bash"
    fi
  fi
  echo -ne "${shell}"
}
resolveTenvHome() {
  local cwd="$(pwd)"
  local tenv=$(which tenv)
  cd "`dirname ${tenv}`"
  local path=`$(type -p greadlink readlink | head -1) "${tenv}"`
  if [ -n "${path}" ]; then
    cd "`dirname ${path}`"
  fi
  pwd
  cd "${cwd}"
}
initTenv() {
  local shell="$(resolveShell)"
  local tenvHome=$(resolveTenvHome)
  case "${shell}" in
    zsh )
      cat << EOF
source "${tenvHome}/../${TERMINAL_INITZSH_FILENAME}"
EOF
      ;;
    bash )
      cat << EOF
source "${tenvHome}/../${TERMINAL_INITBASH_FILENAME}"
EOF
      ;;
    *   ) ;;
  esac
}

# *** information **************************************************************
printVersion() {
  echo "${TENV_VERSION}"
}
printHelp() {
  cat << EOF
tenv ${TENV_VERSION}
Usage: tenv <command>

tenv commands are:
  version : Print tenv version information
  help    : Print tenv help (this message)
  set     : Set config to the terminal app
EOF
}

# *** main *********************************************************************
command="$1"
case "$command" in
  "-v" | "version"   ) printVersion ;;
  "" | "-h" | "help" ) printHelp    ;;
  "init"             ) initTenv     ;;
  "set"              ) setTenv      ;;
  *                  ) printHelp    ;;
esac
