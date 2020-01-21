#!/bin/bash -Ee

readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
readonly tmp_dir=$(mktemp -d "/tmp/cyber-dojo-start-points-base.XXX")
remove_tmp_dir() { rm -rf "${tmp_dir}" > /dev/null; }
trap remove_tmp_dir INT EXIT

# - - - - - - - - - - - - - - - - - - - - - - - -
ensure_cyber_dojo_is_on_PATH()
{
  local -r name=cyber-dojo
  if [ ! -x "$(command -v ${name})" ]; then
    local -r url="https://raw.githubusercontent.com/cyber-dojo/commander/master/${name}"
    >&2 echo "Did not find executable [${name}] on the PATH"
    >&2 echo "Curling [cyber-dojo] script into tmp-dir from ${url}"
    curl --fail --output "${tmp_dir}/${name}" --silent "${url}"
    chmod 700 "${tmp_dir}/${name}"
    >&2 echo 'Adding tmp-dir to PATH'
    PATH="${tmp_dir}:${PATH}"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
ensure_cyber_dojo_is_on_PATH

if [ "$1" = '' ]; then
  for test_file in ${my_dir}/test_*; do
    ${test_file}
  done
else
  for glob in "$@"; do
    for test_file in ${my_dir}/test_*${glob}*; do
      ${test_file}
    done
  done
fi
