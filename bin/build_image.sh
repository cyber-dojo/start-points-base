#!/usr/bin/env bash
set -Eeu

root_dir() { git rev-parse --show-toplevel; }
export -f root_dir
rm -rf "$(root_dir)/tmp" && mkdir "$(root_dir)/tmp"

source $(root_dir)/bin/build_base_docker_image.sh
source $(root_dir)/bin/build_docker_images.sh
source $(root_dir)/bin/config.sh
source $(root_dir)/bin/echo_env_vars.sh
source $(root_dir)/bin/exit_non_zero_unless_installed.sh
source $(root_dir)/bin/lib.sh
source $(root_dir)/bin/tag_and_push_base_docker_image.sh


exit_non_zero_unless_installed docker
exit_non_zero_unless_root_dir_in_context
# 'make test_image' creates a fake cyberdojo/versioner so ensure start with a real one
docker pull --platform=linux/amd64 cyberdojo/versioner:latest
export $(echo_env_vars)

build_base_docker_image          # Builds  cyberdojo/start-points-base:latest
tag_and_push_base_docker_image   # Tags to cyberdojo/start-points-base:TAG (based on short-sha)
