
The source for the cyberdojo/start-points-base docker-image
which acts as a base image for creating a cyber-dojo docker-image
containing specified cyber-dojo start-points.

Use the
[build_cyber_dojo_start_points_image.sh](../build_cyber_dojo_start_point_image.sh)
script to create your own cyber-dojo start-point image. For example
```
$ build_cyber_dojo_start_points_image.sh --help
use: build_cyber_dojo_start_point_image.sh <image-name> <git-repo-urls>
...
$ build_cyber_dojo_start_points_image.sh \
    acme/my-start-points \
      https://github.com/cyber-dojo/start-points.git
```

There are 3 kinds of start-points
- languages
- exercises
- custom
