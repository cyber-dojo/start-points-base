#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$( dirname "${0}" )" && pwd )"

"${SH_DIR}/build_base_docker_image.sh"
"${SH_DIR}/build_docker_images.sh"
"${SH_DIR}/build_test_derived_images.sh"
"${SH_DIR}/docker_containers_up.sh"
