#!/bin/bash
set -e

readonly SH_DIR="$( cd "$( dirname "${0}" )/sh" && pwd )"

"${SH_DIR}/build_docker_images.sh"
