
[![Github Action (main)](https://github.com/cyber-dojo/start-points-base/actions/workflows/main.yml/badge.svg)](https://github.com/cyber-dojo/start-points-base/actions)

The source for the [cyberdojo/start-points-base](https://hub.docker.com/r/cyberdojo/start-points-base) docker image.

* You use the $[cyber-dojo](https://github.com/cyber-dojo/commander/blob/master/cyber-dojo) ```start-point create ...``` command to create your own start-point images.
  ```bash
  $ cyber-dojo start-point create --help
    Use:
    cyber-dojo start-point create <name> --custom    <url>...
    cyber-dojo start-point create <name> --exercises <url>...
    cyber-dojo start-point create <name> --languages <url>...
    ...
  ```

* If successful, the created image <name> will use [cyberdojo/start-points-base](https://hub.docker.com/r/cyberdojo/start-points-base) as its base (FROM) image and will http-serve (copies of) the start-points in the urls when named in a [cyber-dojo up] command. For example:
  <pre>
  $ cyber-dojo start-point create \
        <b>acme/my-languages-start-points</b> \
          --languages \
            https://github.com/cyber-dojo-languages/csharp-nunit             \
            https://github.com/cyber-dojo-languages/gplusplus-googlemock.git \
            https://github.com/cyber-dojo-languages/java-junit.git
  ...
  Successfully built acme/my-languages-start-points

  $ cyber-dojo up --languages=<b>acme/my-languages-start-points</b>
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
There are 2 kinds of start-points
- languages/custom. These are specified with full [manifest.json](https://blog.cyber-dojo.org/2016/08/cyber-dojo-start-points-manifestjson.html) files.
- exercises. These are specified with a subset of the languages/custom manifest.json files and have only two entries:
  - You must specify a display_name
  - You must specify the visible_filenames
    - visible_filenames cannot contain a file called cyber-dojo.sh

- - - -
# API
- [GET alive?()](#get-alive)
- [GET ready?()](#get-ready)
- [GET sha()](#get-sha)
#
- [GET names()](#get-names)
- [GET manifests()](#get-manifests)
- [GET manifest(name)](#get-manifestname)
- [GET image_names()](#get-imagenames)

- - - -
# JSON in, JSON out  
* All API calls receive a JSON hash.
  * The hash contains any arguments as key-value pairs.
* All API calls return a JSON hash.
  * If the call completes, a key equals the call name.
  * If the call raises an exception, a key equals "exception".

- - - -
### GET alive?()
Useful as a liveness probe.
- returns
  * true
  ```json
    { "alive?": true }
  ```
- parameters
  * none
  ```json
    {}
  ```

- - - -
### GET ready?()
Useful as a readiness probe.
- returns
  * true if the service is ready
  ```json
    { "ready?": true }
  ```  
  * false if the service is not ready
  ```json
    { "ready?": false }
  ```
- parameters
  * none
  ```json
    {}
  ```

- - - -
### GET sha()
The git commit sha used to create the docker image.
- returns
  * The 40 character sha string
  * eg
  ```json
    { "sha": "b28b3e13c0778fe409a50d23628f631f87920ce5" }
  ```
- parameters
  * none
  ```json
    {}
  ```

- - - -
### GET names()
The display_names from all manifests.
- returns
  * A sorted array of strings.
  * eg
  ```json
    { "names": [
        "C (gcc), assert",
        "C#, NUnit",
        "C++ (g++), assert",
        "Python, py.test",
        "Python, unittest"
      ]
    }
  ```
- parameters
  * none
  ```json
    {}
  ```

- - - -
### GET manifests()
...

- - - -
### GET manifest(name)
The manifest for the given name.
- returns
  * eg
  ```json
    { "manifest": {
        "display_name": "C#, NUNit",
        "image_name": "cyberdojofoundation/csharp_nunit",
        "filename_extension": [ ".cs" ],
        "visible_files": {
          "Hiker.cs": {               
            "content": "public class Hiker..."
          },
          "HikerTest.cs": {
            "content": "using NUnit.Framework;..."
          },
          "cyber-dojo.sh": {
            "content": "NUNIT_PATH=/nunit/lib/net45..."
          }
        }
      }
    }
  ```
- parameters
  * **name:String** from a previous call to the names method above
  * eg
  ```json
    {  "name": "C#, NUnit" }
  ```

- - - -
### GET image_names()
The image_names from all manifests.
- returns
  * A sorted array of strings.
  * eg
  ```json
    { "image_names": [
        "cyberdojofoundation/csharp_nunit",
        "cyberdojofoundation/python_unittest",
        "cyberdojofoundation/ruby_mini_test"
      ]
    }
  ```
- parameters
  * none
  ```json
    {}
  ```

- - - -

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
