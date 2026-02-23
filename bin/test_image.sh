#!/usr/bin/env bash
set -Eeu

root_dir() { git rev-parse --show-toplevel; }
export -f root_dir
rm -rf "$(root_dir)/tmp" && mkdir "$(root_dir)/tmp"

source $(root_dir)/bin/build_docker_images.sh
source $(root_dir)/bin/build_fake_versioner_image.sh
source $(root_dir)/bin/build_test_derived_images.sh
source $(root_dir)/bin/config.sh
source $(root_dir)/bin/docker_containers_up.sh
source $(root_dir)/bin/echo_env_vars.sh
source $(root_dir)/bin/exit_non_zero_unless_installed.sh
source $(root_dir)/bin/lib.sh
source $(root_dir)/bin/run_script_tests.sh
source $(root_dir)/bin/run_tests_in_containers.sh


exit_non_zero_unless_installed docker
exit_non_zero_unless_root_dir_in_context

build_fake_versioner_image        # Because tests call the top-level cyber-dojo bash script
trap 'docker image rm --force cyberdojo/versioner:latest' EXIT
export $(echo_env_vars)

build_docker_images
build_test_derived_images
#docker_containers_up
#run_tests_in_containers "$@"
export CYBER_DOJO_DEBUG=false
run_script_tests "$@"
