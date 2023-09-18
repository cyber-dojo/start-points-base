#!/usr/bin/env bash
set -Eeu

docker build \
  --tag cyberdojo/create-start-points-test-data \
  "$(root_dir)/test_data"

