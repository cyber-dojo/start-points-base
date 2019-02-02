set -e
readonly SH_DIR="$( cd "$( dirname "${0}" )/sh" && pwd )"

"${SH_DIR}/build_base_docker_image.sh"
"${SH_DIR}/build_docker_images.sh"
"${SH_DIR}/run_script_tests.sh" "${*}"
