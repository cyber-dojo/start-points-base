#!/bin/bash

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

export DONT_PULL_START_POINTS_BASE=true
${MY_DIR}/build_base_docker_image.sh

${MY_DIR}/../cyber_dojo_start_points_create.sh \
  acme/spl \
    --custom \
      file:///Users/jonjagger/repos/cyber-dojo/start-points-custom

${MY_DIR}/../cyber_dojo_start_points_create.sh \
  acme/spe \
    --exercises \
      file:///Users/jonjagger/repos/cyber-dojo/start-points-exercises

${MY_DIR}/../../commander/cyber-dojo up \
  --languages=ruby-minitest \
  --starter=acme/ruby_mini_test2
