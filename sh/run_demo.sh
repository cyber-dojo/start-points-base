#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"${SH_DIR}/build_base_docker_image.sh"
"${SH_DIR}/build_docker_images.sh"

docker-compose \
  --file "${SH_DIR}/../docker-compose.yml" \
  up \
  --detach  \
  --force-recreate

if [ -n "${DOCKER_MACHINE_NAME}" ]; then
  declare ip=$(docker-machine ip "${DOCKER_MACHINE_NAME}")
else
  declare ip=localhost
fi

sleep 1
open "http://${ip}:4528"
