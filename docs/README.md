
The source for the cyberdojo/start-points-base docker-image
which acts as a base image for creating a cyber-dojo docker-image
that contains cyber-dojo start-points.
There are 3 kinds of start-points
- languages
- exercises
- custom

Use the build_cyber_dojo_start_points_image.sh script to create your own
cyber-dojo start-point image. For example
```
$ build_cyber_dojo_start_points_image.sh --help
$ build_cyber_dojo_start_points_image.sh \
    acme/my-start-points \
      https://github.com/cyber-dojo/start-points.git
```
