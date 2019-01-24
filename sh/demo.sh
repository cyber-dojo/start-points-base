#!/bin/bash
set -e
readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"
"${SH_DIR}/pipe_build_up.sh"
if [ ! -z "${DOCKER_MACHINE_NAME}" ]; then
  declare ip=$(docker-machine ip "${DOCKER_MACHINE_NAME}")
else
  declare ip=localhost
fi
echo "demo -> ${ip}:4528"
