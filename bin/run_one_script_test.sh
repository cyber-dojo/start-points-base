#!/usr/bin/env bash
set -Eeu

# Runs a single script test (or a substring-matched subset) from
# test_script/, after rebuilding the base image and the test-data image so
# the run reflects current source under app/src/ and test_data/.
#
# This is the fast inner-loop alternative to 'make test_image', which builds
# every derived image and runs the whole suite in containers. We deliberately
# do only what a script test needs: a current base image, a fake
# cyberdojo/versioner:latest (so commander's 'start-point create' builds FROM
# the base image we just built), the test-data image, then run_tests.sh.

# Suppress the Docker CLI "What's next: ... docker scout quickview" hints.
export DOCKER_CLI_HINTS=false

# Build/run amd64 images even on an arm64 host (eg Apple Silicon), so local
# builds match the amd64 images produced by CI.
export DOCKER_DEFAULT_PLATFORM=linux/amd64

root_dir() { git rev-parse --show-toplevel; }
export -f root_dir

show_help()
{
  # Print usage help to stdout.
  cat <<EOF
Usage: bin/run_one_script_test.sh <test-name>

Runs only the script test(s) in test_script/ whose filename matches
*<test-name>* (substring match, the same globbing run_tests.sh uses).
First rebuilds the base image and the test-data image so the run reflects
current source under app/src/ and test_data/. Use this for fast iteration
on a single script test instead of the full 'make test_image' suite.

Options:
  -h    Show this help

Example:
  bin/run_one_script_test.sh language_test_framework_together
  make test_one TEST=language_test_framework_together
EOF
}

case "${1:-}" in
  -h)
    show_help
    exit 0
    ;;
  '')
    >&2 echo "ERROR: missing <test-name> argument"
    show_help >&2
    exit 2
    ;;
esac

rm -rf "$(root_dir)/tmp" && mkdir "$(root_dir)/tmp"

source "$(root_dir)/bin/config.sh"
source "$(root_dir)/bin/lib.sh"
source "$(root_dir)/bin/exit_non_zero_unless_installed.sh"
source "$(root_dir)/bin/build_fake_versioner_image.sh"
source "$(root_dir)/bin/echo_env_vars.sh"
source "$(root_dir)/bin/build_base_docker_image.sh"
source "$(root_dir)/bin/tag_base_docker_image.sh"
source "$(root_dir)/bin/build_test_derived_images.sh"
source "$(root_dir)/bin/run_script_tests.sh"

exit_non_zero_unless_installed docker
exit_non_zero_unless_root_dir_in_context

# Make cyberdojo/versioner:latest the fake that serves this repo's SHA/TAG,
# then export the env-vars commander needs to find the base image.
docker pull --platform=linux/amd64 cyberdojo/versioner:latest
build_fake_versioner_image
trap 'docker image rm --force cyberdojo/versioner:latest' EXIT
export $(echo_env_vars)

# Rebuild the base image so production checks under app/src/ are current.
build_base_docker_image
tag_base_docker_image

# Rebuild the image that creates the test-data git repos, so fixture changes
# in test_data/make_data_set.rb are current.
build_image_which_creates_test_data_git_repos

export CYBER_DOJO_DEBUG=false
run_script_tests "$@"
