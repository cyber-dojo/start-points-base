#!/usr/bin/env bash
set -Eeu

stderr()
{
  local -r message="${1}"
  >&2 echo "${message}"
}

on_Mac()
{
  # detect OS from bash: https://stackoverflow.com/questions/394230
  [[ "${OSTYPE:-}" == "darwin"* ]]
}

on_ci()
{
  [ -n "${CI:-}" ]
}

exit_non_zero_unless_root_dir_in_context()
{
  if on_Mac; then
    local -r repo_root=$(root_dir)
    if [ "${repo_root:0:6}" != '/Users' ]; then
      stderr 'ERROR'
      stderr "This script lives off $(root_dir)"
      stderr 'It must live off /Users so the docker-context'
      stderr "is automatically volume-mounted"
      exit 42
    fi
  fi
}
