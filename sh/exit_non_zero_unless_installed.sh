
exit_non_zero_unless_installed()
{
  local -r package="${1}"
  printf "Checking %s is installed..." "${package}"
  if ! installed "${package}" ; then
    stderr "ERROR: ${package} is not installed!"
    exit 42
  else
    echo It is
  fi
}

installed()
{
  if hash "${1}" 2> /dev/null; then
    true
  else
    false
  fi
}

stderr()
{
  >&2 echo "${1}"
}
