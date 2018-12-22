
[![CircleCI](https://circleci.com/gh/cyber-dojo/start-points-base.svg?style=svg)](https://circleci.com/gh/cyber-dojo/start-points-base)

Work-in-progress. Not used yet.

The source for the cyberdojo/start-points-base docker-image.
Use the [build_cyber_dojo_start_points_image.sh](../build_cyber_dojo_start_point_image.sh)
script to create your cyber-dojo starter docker-image
(which will have use cyberdojo/start-points-base as its base image).
The first argument is the name of the image you want to create.
The subsequent arguments are git-cloneable URLs containing the source for the start-points.

```
$ build_cyber_dojo_start_points_image.sh --help
use: build_cyber_dojo_start_point_image.sh <image-name> <git-clone-urls>

$ build_cyber_dojo_start_points_image.sh \
    acme/my-start-points \
      https://github.com/cyber-dojo/start-points-languages.git \
      https://github.com/cyber-dojo/start-points-exercises.git \
      https://github.com/cyber-dojo/start-points-custom.git    \
```

There are 3 kinds of start-points
- languages...
- exercises...
- custom...
