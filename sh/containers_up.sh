#!/bin/bash
set -e

wait_until_ready()
{
  local name="${1}"
  local port="${2}"
  local max_tries=20
  local cmd="curl --silent --fail --data '{}' -X GET http://localhost:${port}/ready"
  cmd+=" > /dev/null 2>&1"

  if [ -n "${DOCKER_MACHINE_NAME}" ]; then
    cmd="docker-machine ssh ${DOCKER_MACHINE_NAME} ${cmd}"
  fi
  echo -n "Waiting until ${name} is ready"
  for _ in $(seq ${max_tries})
  do
    echo -n '.'
    if eval "${cmd}" ; then
      echo 'OK'
      return
    else
      sleep 0.1
    fi
  done
  echo 'FAIL'
  echo "${name} not ready after ${max_tries} tries"
  docker logs "${name}"
  exit 1
}

# - - - - - - - - - - - - - - - - - - - -

exit_unless_clean()
{
  local name="${1}"
  local docker_logs=$(docker logs "${name}")
  echo -n "Checking ${name} started cleanly..."
  if [ -z "${docker_logs}" ]; then
    echo 'OK'
  else
    echo 'FAIL'
    echo "[docker logs ${name}] not empty on startup"
    echo "<docker_logs>"
    echo "${docker_logs}"
    echo "</docker_logs>"
    exit 1
  fi
}

# - - - - - - - - - - - - - - - - - - - -

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  up \
  -d  \
  --force-recreate \
  starter_client

readonly CUSTOM_CONTAINER_NAME=test-custom-server
readonly EXERCISES_CONTAINER_NAME=test-exercises-server
readonly LANGUAGES_CONTAINER_NAME=test-languages-server

wait_until_ready  "${CUSTOM_CONTAINER_NAME}" 4526
exit_unless_clean "${CUSTOM_CONTAINER_NAME}"

wait_until_ready  "${EXERCISES_CONTAINER_NAME}" 4525
exit_unless_clean "${EXERCISES_CONTAINER_NAME}"

wait_until_ready  "${LANGUAGES_CONTAINER_NAME}" 4524
exit_unless_clean "${LANGUAGES_CONTAINER_NAME}"

#wait_until_ready  "test-starter-client" 4528
#exit_unless_clean "test-starter-client"
