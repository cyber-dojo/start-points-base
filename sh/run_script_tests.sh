#!/usr/bin/env bash
set -Eeu

run_script_tests()
{
  "$(root_dir)/test_script/run_tests.sh" "$@"
}
