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

build_fake_versioner_image       # Because tests call the top-level cyber-dojo bash script
trap 'docker image rm --force cyberdojo/versioner:latest' EXIT
export $(echo_env_vars)

build_base_docker_image          # Builds  cyberdojo/start-points-base:latest
tag_base_docker_image            # Tags to cyberdojo/start-points-base:TAG (based on short-sha) and does docker push
exit_zero_if_build_only "$@"

build_docker_images
build_test_derived_images
docker_containers_up
run_tests_in_containers "$@"
run_script_tests "$@"
on_ci_publish_tagged_images
