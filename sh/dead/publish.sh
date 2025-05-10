#!/usr/bin/env bash
set -Eeu

root_dir() { git rev-parse --show-toplevel; }
export -f root_dir

for script in "$(root_dir)/sh"/*.sh; do
  source "${script}"
done

exit_non_zero_unless_installed docker
export $(echo_env_vars)
on_ci_publish_tagged_images
