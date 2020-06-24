#!/bin/bash -Eeu

readonly MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly SH_DIR="${MY_DIR}/sh"
rm -rf "${MY_DIR}/tmp" && mkdir "${MY_DIR}/tmp"

source ${SH_DIR}/versioner_env_vars.sh
export $(versioner_env_vars)
"${SH_DIR}/build_base_docker_image.sh"
"${SH_DIR}/tag_image.sh"
if [ "${1:-}" == --build-only ] || [ "${1:-}" == -bo ]; then
  exit 0
fi
"${SH_DIR}/build_docker_images.sh"
trap 'docker image rm --force cyberdojo/versioner:latest' EXIT
"${SH_DIR}/build_fake_versioner_image.sh"
"${SH_DIR}/build_test_derived_images.sh"
"${SH_DIR}/docker_containers_up.sh"
"${SH_DIR}/run_tests_in_containers.sh" "$@"
"${SH_DIR}/run_script_tests.sh"
"${SH_DIR}/on_ci_publish_tagged_images.sh"

# To update dependent:
#  - custom-start-points
#  - exercises-start-points
#  - languages-start-points
# you must update cyberdojo/versioner with
# a new .env file with the new values of
# CYBER_DOJO_START_POINTS_BASE_SHA
# CYBER_DOJO_START_POINTS_BASE_TAG
