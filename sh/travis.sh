#!/bin/bash
set -e

readonly SCRIPT=build_cyber_dojo_start_points_image.sh
readonly MY_IMAGE_NAME=cyberdojo/start-points-base-test

chmod +x ./${SCRIPT}

./${SCRIPT} \
  ${MY_IMAGE_NAME} \
    https://github.com/cyber-dojo/start-points-languages.git \
    https://github.com/cyber-dojo/start-points-exercises.git \
    https://github.com/cyber-dojo/start-points-custom.git    \
