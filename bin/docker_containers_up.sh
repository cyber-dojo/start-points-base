#!/usr/bin/env bash
set -Eeu

ip_address()
{
  echo localhost
}

curl_output_path()
{
  echo /tmp/curl-probe
}

curl_cmd()
{
  local -r port="${1}"
  local -r path="${2}"
  local -r cmd="curl --output $(curl_output_path) --silent --fail -X GET http://$(ip_address):${port}/${path}"
  if ${cmd} && [ "$(cat "$(curl_output_path)")" == '{"ready?":true}' ]; then
    true
  else
    false
  fi
}

wait_until_ready()
{
  local -r name="${1}"
  local -r port="${2}"
  local -r max_tries=20
  printf "Waiting until %s is ready" "${name}"
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
  if [ -f "$(curl_output_path)" ]; then
    cat "$(curl_output_path)"
  fi
  docker logs "${name}"
  exit 1
}

# Verify a server container started cleanly: its log must begin with the normal
# Puma startup banner and nothing before it (no warnings/errors). The exact Puma
# version and codename on line 2 are determined by the base image's FROM and
# change whenever the base image is updated, so match line 2 by prefix rather
# than pinning the full version string.
exit_unless_clean()
{
  local -r container_name="${1}"
  local -r docker_log=$(docker logs "${container_name}" 2>&1)
  local -r line1=$(echo "${docker_log}" | sed -n '1p')
  local -r line2=$(echo "${docker_log}" | sed -n '2p')
  if [ "${line1}" == "Puma starting in single mode..." ] \
  && [[ "${line2}" == '* Puma version: '* ]]; then
    echo "${container_name} started cleanly."
  else
    echo "${container_name} did not start cleanly."
    echo_docker_log "${container_name}" "${docker_log}"
    exit 42
  fi
}

echo_docker_log()
{
  local -r container_name="${1}"
  local -r docker_log="${2:-$(docker logs "${container_name}")}"
  echo "[docker logs ${container_name}]"
  echo "<docker_log>"
  echo "${docker_log}"
  echo "</docker_log>"
  printf '\n'
}

docker_containers_up()
{
  echo
  docker compose \
    --file "$(root_dir)/docker-compose.yml" \
    up \
    --detach  \
    --force-recreate \
    starter_client

  local -r CUSTOM_CONTAINER_NAME=test-custom-server
  local -r EXERCISES_CONTAINER_NAME=test-exercises-server
  local -r LANGUAGES_CONTAINER_NAME=test-languages-server

  echo
  wait_until_ready  "${CUSTOM_CONTAINER_NAME}" 4526
  exit_unless_clean "${CUSTOM_CONTAINER_NAME}"

  wait_until_ready  "${EXERCISES_CONTAINER_NAME}" 4525
  exit_unless_clean "${EXERCISES_CONTAINER_NAME}"

  wait_until_ready  "${LANGUAGES_CONTAINER_NAME}" 4524
  exit_unless_clean "${LANGUAGES_CONTAINER_NAME}"

  # wait_until_ready  "test-starter-client" 4528
  # exit_unless_clean "test-starter-client"
  echo
}
