#!/usr/bin/env bash
set -Eeu

root_dir() { git rev-parse --show-toplevel; }
export -f root_dir
rm -rf "$(root_dir)/tmp" && mkdir "$(root_dir)/tmp"

for script in "$(root_dir)/sh"/*.sh; do
  source "${script}"
done

exit_non_zero_unless_installed docker
exit_non_zero_unless_root_dir_in_context
on_ci_upgrade_docker_compose

build_fake_versioner_image
trap 'docker image rm --force cyberdojo/versioner:latest' EXIT
export $(echo_versioner_env_vars)

build_base_docker_image
tag_base_docker_image
exit_zero_if_build_only "$@"
build_docker_images
build_test_derived_images
docker_containers_up
run_tests_in_containers "$@"
run_script_tests "$@"
on_ci_publish_tagged_images
