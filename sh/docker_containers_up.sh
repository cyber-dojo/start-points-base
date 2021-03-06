#!/bin/bash -Ee

# - - - - - - - - - - - - - - - - - - - -
ip_address()
{
  if [ -n "${DOCKER_MACHINE_NAME}" ]; then
    docker-machine ip ${DOCKER_MACHINE_NAME}
  else
    echo localhost
  fi
}

readonly IP_ADDRESS=$(ip_address)

# - - - - - - - - - - - - - - - - - - - -
curl_cmd()
{
  local -r port="${1}"
  local -r path="${2}"
  local -r cmd="curl --output /tmp/curl-probe --silent --fail -X GET http://${IP_ADDRESS}:${port}/${path}"
  if ${cmd} && [ "$(cat /tmp/curl-probe)" = '{"ready?":true}' ]; then
    true
  else
    false
  fi
}

# - - - - - - - - - - - - - - - - - - - -
wait_until_ready()
{
  local -r name="${1}"
  local -r port="${2}"
  local -r max_tries=20
  printf "Waiting until ${name} is ready"
  for _ in $(seq ${max_tries})
  do
    if curl_cmd ${port} ready? ; then
      printf '.OK\n'
      return
    else
      printf '.'
      sleep 0.1
    fi
  done
  printf 'FAIL\n'
  echo "${name} not ready after ${max_tries} tries"
  if [ -f /tmp/curl-probe ]; then
    echo "$(cat /tmp/curl-probe)"
  fi
  docker logs ${name}
  exit 1
}

# - - - - - - - - - - - - - - - - - - - -
exit_unless_clean()
{
  local -r name="${1}"
  local -r docker_log=$(docker logs "${name}")
  local -r line_count=$(echo -n "${docker_log}" | grep --count '^')
  echo -n "Checking ${name} started cleanly..."
  # puma startup log has 6 lines
  if [ "${line_count}" == '6' ]; then
    echo 'OK'
  else
    echo 'FAIL'
    echo_docker_log "${name}" "${docker_log}"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - -
echo_docker_log()
{
  local -r name="${1}"
  local -r docker_log="${2:-$(docker logs "${name}")}"
  echo "[docker logs ${name}]"
  echo "<docker_log>"
  echo "${docker_log}"
  echo "</docker_log>"
  printf '\n'
}

# - - - - - - - - - - - - - - - - - - - -

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

echo
docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  up \
  --detach  \
  --force-recreate \
  starter_client

readonly CUSTOM_CONTAINER_NAME=test-custom-server
readonly EXERCISES_CONTAINER_NAME=test-exercises-server
readonly LANGUAGES_CONTAINER_NAME=test-languages-server

echo
wait_until_ready  "${CUSTOM_CONTAINER_NAME}" 4526
exit_unless_clean "${CUSTOM_CONTAINER_NAME}"

wait_until_ready  "${EXERCISES_CONTAINER_NAME}" 4525
exit_unless_clean "${EXERCISES_CONTAINER_NAME}"

wait_until_ready  "${LANGUAGES_CONTAINER_NAME}" 4524
exit_unless_clean "${LANGUAGES_CONTAINER_NAME}"

#wait_until_ready  "test-starter-client" 4528
#exit_unless_clean "test-starter-client"
echo
