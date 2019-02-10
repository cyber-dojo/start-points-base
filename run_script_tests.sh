set -e
readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
rm -rf "${MY_DIR}/tmp" && mkdir "${MY_DIR}/tmp"
"${MY_DIR}/sh/build_base_docker_image.sh"
"${MY_DIR}/test_data/build_docker_image.sh"
"${MY_DIR}/sh/run_script_tests.sh" ${*}
