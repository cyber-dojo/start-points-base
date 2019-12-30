#!/bin/bash -Ee

readonly root_dir="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_tests()
{
  local -r coverage_root=/tmp/coverage
  local -r user="${1}"
  local -r test_dir="${2}"
  local -r cid=$(docker ps --all --quiet --filter "name=${3}")

  set +e
  docker exec \
    --user "${user}" \
    --env COVERAGE_ROOT=${coverage_root} \
    "${cid}" \
      sh -c "/app/test/util/run.sh ${@:4}"

  local status=$?
  set -e
  if [ "${status}" != '0' ]; then
    docker logs "${cid}"
    exit 42
  fi

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
run_server_tests()
{
  echo 'Running custom tests'
  run_tests nobody test_custom_server    test-custom-server    "$@"
  echo 'Running exercises tests'
  run_tests nobody test_exercises_server test-exercises-server "$@"
  echo 'Running languages tests'
  run_tests nobody test_languages_server test-languages-server "$@"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_client_tests()
{
  run_tests nobody test_client test-starter-client "$@"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "${1}" = 'server' ]; then
  shift
  run_server_tests "$@"
elif [ "${1}" = 'client' ]; then
  shift
  run_client_tests "$@"
else
  run_server_tests "$@"
  run_client_tests "$@"
fi
echo '------------------------------------------------------'
echo 'All passed'
echo
