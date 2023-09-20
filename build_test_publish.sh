#!/usr/bin/env bash
set -Eeu

root_dir() { git rev-parse --show-toplevel; }
sh_dir() { echo "$(root_dir)/sh"; }
export -f root_dir
rm -rf "$(root_dir)/tmp" && mkdir "$(root_dir)/tmp"

. "$(sh_dir)/lib.sh"
. "$(sh_dir)/config.sh"
. "$(sh_dir)/exit_non_zero_unless_installed.sh"
. "$(sh_dir)/on_ci_upgrade_docker_compose.sh"
. "$(sh_dir)/build_fake_versioner_image.sh"
. "$(sh_dir)/echo_versioner_env_vars.sh"
. "$(sh_dir)/build_base_docker_image.sh"
. "$(sh_dir)/tag_base_docker_image.sh"
. "$(sh_dir)/exit_zero_if_build_only.sh"
. "$(sh_dir)/build_docker_images.sh"
. "$(sh_dir)/build_test_derived_images.sh"
. "$(sh_dir)/docker_containers_up.sh"
. "$(sh_dir)/run_tests_in_containers.sh"
. "$(sh_dir)/run_script_tests.sh"
. "$(sh_dir)/on_ci_publish_tagged_images.sh"

exit_non_zero_unless_installed docker docker-compose
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
# on_ci_publish_tagged_images


# Dependents of start-points-base are:
#   custom-start-points
#   exercises-start-points
#   languages-start-points
# To update these
#   - update cyberdojo/versioner with
#     a new .env file with the new values of
#     CYBER_DOJO_START_POINTS_BASE_SHA
#     CYBER_DOJO_START_POINTS_BASE_TAG
#   - build a new versioner
#   - force rebuild the dependents
