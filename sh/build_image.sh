#!/usr/bin/env bash
set -Eeu

root_dir() { git rev-parse --show-toplevel; }
export -f root_dir
rm -rf "$(root_dir)/tmp" && mkdir "$(root_dir)/tmp"

source $(root_dir)/sh/build_base_docker_image.sh
source $(root_dir)/sh/build_docker_images.sh
source $(root_dir)/sh/config.sh
source $(root_dir)/sh/echo_env_vars.sh
source $(root_dir)/sh/exit_non_zero_unless_installed.sh
source $(root_dir)/sh/lib.sh
source $(root_dir)/sh/tag_and_push_base_docker_image.sh


exit_non_zero_unless_installed docker
exit_non_zero_unless_root_dir_in_context
export $(echo_env_vars)

build_base_docker_image          # Builds  cyberdojo/start-points-base:latest
tag_and_push_base_docker_image   # Tags to cyberdojo/start-points-base:TAG (based on short-sha)
