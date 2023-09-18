#!/usr/bin/env bash
set -Eeu

root_dir() { git rev-parse --show-toplevel; }
sh_dir() { echo "$(root_dir)/sh"; }
export -f root_dir
rm -rf "$(root_dir)/tmp" && mkdir "$(root_dir)/tmp"

source "$(sh_dir)/versioner_env_vars.sh"
export $(versioner_env_vars)

. "$(sh_dir)/on_ci_upgrade_docker_compose.sh"
. "$(sh_dir)/build_base_docker_image.sh"
. "$(sh_dir)/tag_image.sh"
. "$(sh_dir)/exit_zero_if_build_only.sh"
. "$(sh_dir)/build_docker_images.sh"
trap 'docker image rm --force cyberdojo/versioner:latest' EXIT
. "$(sh_dir)/build_fake_versioner_image.sh"
. "$(sh_dir)/build_test_derived_images.sh"
. "$(sh_dir)/docker_containers_up.sh"
. "$(sh_dir)/run_tests_in_containers.sh"
. "$(sh_dir)/run_script_tests.sh"
. "$(sh_dir)/on_ci_publish_tagged_images.sh"

exit_if_ROOT_DIR_not_in_context
on_ci_upgrade_docker_compose
build_base_docker_image
tag_image
exit_zero_if_build_only "$@"
build_docker_images
build_fake_versioner_image
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
