#!/bin/bash

readonly root_dir="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# - - - - - - - - - - - - - - - - - - - - - - - - - -

run_tests()
{
  local coverage_root=/tmp/coverage
  local user="${1}"
  local test_dir="${2}"
  local cid=$(docker ps --all --quiet --filter "name=${3}")

  docker exec \
    --user "${user}" \
    --env COVERAGE_ROOT=${coverage_root} \
    "${cid}" \
      sh -c "/app/test/util/run.sh ${@:4}"

  local status=$?

  # You can't [docker cp] from a tmpfs, so tar-piping coverage out.
  docker exec "${cid}" \
    tar Ccf \
      "$(dirname "${coverage_root}")" \
      - "$(basename "${coverage_root}")" \
        | tar Cxf "${root_dir}/${test_dir}/" -

  echo "Coverage report copied to ${test_dir}/coverage/"
  cat "${root_dir}/${test_dir}/coverage/done.txt"
  return ${status}
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -

declare custom_server_status=0
declare exercises_server_status=0
declare languages_server_status=0
declare client_status=0

run_server_tests()
{
  run_tests nobody test_custom_server test-custom-server "${*}"
  custom_server_status=$?
  run_tests nobody test_exercises_server test-exercises-server "${*}"
  exercises_server_status=$?
  run_tests nobody test_languages_server test-languages-server "${*}"
  languages_server_status=$?
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -

run_client_tests()
{
  run_tests nobody test_client test-starter-client "${*}"
  client_status=$?
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ "$1" = 'server' ]; then
  shift
  run_server_tests "$@"
elif [ "$1" = 'client' ]; then
  shift
  run_client_tests "$@"
else
  run_server_tests "$@"
  run_client_tests "$@"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ "${custom_server_status}" = '0' ] && \
   [ "${exercises_server_status}" = '0' ] && \
   [ "${languages_server_status}" = '0' ] && \
   [ "${client_status}" = '0' ]
then
  echo '------------------------------------------------------'
  echo 'All passed'
  exit 0
else
  echo
  if [ "${custom_server_status}" != '0' ]; then
    echo "test-custom-server: status = ${custom_server_status}"
  fi
  if [ "${exercises_server_status}" != '0' ]; then
    echo "test-exercises-server: status = ${exercises_server_status}"
  fi
  if [ "${languages_server_status}" != '0' ]; then
    echo "test-languages-server: status = ${languages_server_status}"
  fi
  if [ "${client_status}" != '0' ]; then
    echo "test-starter-client: status = ${client_status}"
  fi
  echo
  exit 1
fi
