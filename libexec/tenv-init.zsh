_tenv_export_hook() {
  tenv set
}
install_hook() {
  emulate -LR zsh
  typeset -ag precmd_functions
  if [[ -z $precmd_functions[(r)_tenv_export_hook] ]]; then
        precmd_functions+=_tenv_export_hook;
  fi
}
install_hook

_tenv_export_hook
