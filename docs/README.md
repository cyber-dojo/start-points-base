
[![CircleCI](https://circleci.com/gh/cyber-dojo/start-points-base.svg?style=svg)](https://circleci.com/gh/cyber-dojo/start-points-base)

Work-in-progress. Not used yet.

The source for the cyberdojo/start-points-base docker-image
which acts as a base image for creating a cyber-dojo docker-image
containing specified cyber-dojo start-points using the
[build_cyber_dojo_start_points_image.sh](../build_cyber_dojo_start_point_image.sh)
script:
```
$ build_cyber_dojo_start_points_image.sh --help
use: build_cyber_dojo_start_point_image.sh <image-name> <git-repo-urls>

$ build_cyber_dojo_start_points_image.sh \
    acme/my-start-points \
      https://github.com/cyber-dojo/start-points-languages.git \
      https://github.com/cyber-dojo/start-points-exercises.git \
      https://github.com/cyber-dojo/start-points-custom.git    \
```

There are 3 kinds of start-points
- languages
- exercises
- custom
