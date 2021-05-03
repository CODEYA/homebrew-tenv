#export

_tenv_export_hook() {
  echo "*********************************************** A"
  tenv set
}

if ! [[ "$PROMPT_COMMAND" =~ _tenv_export_hook ]]; then
  echo "*********************************************** B"
   PROMPT_COMMAND="_tenv_export_hook;$PROMPT_COMMAND";
fi


_tenv_export_hook
