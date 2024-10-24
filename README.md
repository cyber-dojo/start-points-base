
[![Github Action (main)](https://github.com/cyber-dojo/start-points-base/actions/workflows/main.yml/badge.svg)](https://github.com/cyber-dojo/start-points-base/actions)

The source for the [cyberdojo/start-points-base](https://hub.docker.com/r/cyberdojo/start-points-base) docker image.
The  image is built in its CI workflow, and is the base image for start-point images created
with the cyber-dojo script (as described below). A newly built start-points-base image only becomes "live" 
after a subsequent update to the [cyberdojo/versioner](https://github.com/cyber-dojo/versioner) image.


* You use the $[cyber-dojo](https://github.com/cyber-dojo/commander/blob/master/cyber-dojo) ```start-point create ...``` command to create your own start-point images.
  ```bash
  $ cyber-dojo start-point create --help
    Use:
    cyber-dojo start-point create <name> --custom    <url>...
    cyber-dojo start-point create <name> --exercises <url>...
    cyber-dojo start-point create <name> --languages <url>...
    ...
  ```

* If successful, the created image <name> will use [cyberdojo/start-points-base](https://hub.docker.com/r/cyberdojo/start-points-base) as its base (FROM) image: 
  <pre>
  $ cyber-dojo start-point create acme/my-languages-start-points:f7d51d0 \
          --languages \
            https://github.com/cyber-dojo-start-points/csharp-nunit         \
            https://github.com/cyber-dojo-start-points/gplusplus-googlemock \
            https://github.com/cyber-dojo-start-points/java-junit
  
  git clone https://github.com/cyber-dojo-start-points/csharp-nunit
  --languages 	 https://github.com/cyber-dojo-start-points/csharp-nunit
  git clone https://github.com/cyber-dojo-start-points/gplusplus-googlemock
  --languages 	 https://github.com/cyber-dojo-start-points/gplusplus-googlemock
  git clone https://github.com/cyber-dojo-start-points/java-junit
  --languages 	 https://github.com/cyber-dojo-start-points/java-junit
  
  Successfully built acme/my-languages-start-points:f7d51d0
  </pre>

  The created image (sinatra based) will http-serve (copies of) the start-points in the urls and can be used 
  in a [cyber-dojo up] command. For example:

  <pre>
  $ cyber-dojo up --languages=acme/my-languages-start-points:f7d51d0
  ...
  Using languages-start-points=acme/my-languages-start-points:f7d51d0
  Using nginx=cyberdojo/nginx:86645b7
  ...
  Container cyber_dojo_languages_start_points:f7d51d0 Starting
  Container cyber_dojo_languages_start_points:f7d51d0 Started
  ...
  </pre>


* If unsuccessful, the command will print an error message. For example:
  ```bash
  $ cyber-dojo start-point create \
      acme/my-custom-start-points --custom /users/fred/custom
  ERROR: no manifest.json files in
  --custom /users/fred/custom
  ```

- - - -

## git-repo-url format
There are 3 kinds of start-points
- languages (default port=4524) These are specified with full [manifest.json](https://blog.cyber-dojo.org/2016/08/cyber-dojo-start-points-manifestjson.html) files. 
- custom (default port=4526). These are specified with full [manifest.json](https://blog.cyber-dojo.org/2016/08/cyber-dojo-start-points-manifestjson.html) files. 
- exercises (default port=4525). These are specified with a subset of the languages/custom manifest.json files and have only two entries:
  - You must specify a display_name
  - You must specify the visible_filenames
    - visible_filenames cannot contain a file called cyber-dojo.sh

- - - -
# API
- [GET alive?()](docs/api.md#get-alive)
- [GET ready?()](docs/api.md#get-ready)
- [GET sha()](docs/api.md#get-sha)
#
- [GET names()](docs/api.md#get-names)
- [GET manifests()](docs/api.md#get-manifests)
- [GET manifest(name)](docs/api.md#get-manifestname)
- [GET image_names()](docs/api.md#get-image_names)

- - - -

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
