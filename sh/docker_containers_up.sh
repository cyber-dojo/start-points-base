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

exit_unless_clean()
{
  local -r container_name="${1}"
  local -r docker_log=$(docker logs "${container_name}" 2>&1)
  local -r top5=$(echo "${docker_log}" | head -5)
  if [ "${top5}" == "$(clean_top_5)" ]; then
    echo "${container_name} started cleanly."
  else
    echo "${container_name} did not start cleanly."
    echo_docker_log "${container_name}" "${docker_log}"
    exit 42
  fi
}

clean_top_5()
{
  # 1st 5 lines on Puma server startup. These are determined by the base image
  # in app/Dockerfile, which is something like this:
  # FROM cyberdojo/docker-base:db948c1

  local -r L1="Puma starting in single mode..."
  local -r L2='* Puma version: 6.6.0 ("Return to Forever")'
  local -r L3='* Ruby version: ruby 3.3.7 (2025-01-15 revision be31f993d7) [x86_64-linux-musl]'
  local -r L4="*  Min threads: 0"
  local -r L5="*  Max threads: 5"
  #
  local -r top5="$(printf "%s\n%s\n%s\n%s\n%s" "${L1}" "${L2}" "${L3}" "${L4}" "${L5}")"
  echo "${top5}"
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
