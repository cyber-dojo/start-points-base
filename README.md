
<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png" alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

[![CircleCI](https://circleci.com/gh/cyber-dojo/starter-base.svg?style=svg)](https://circleci.com/gh/cyber-dojo/starter-base)

The source for the [cyberdojo/starter-base](https://hub.docker.com/r/cyberdojo/starter-base) docker image.

## The build script
* Use the [cyber-dojo](https://github.com/cyber-dojo/commander/blob/master/cyber-dojo)
script to create your own start-point images.
* It will use [cyberdojo/starter-base](https://hub.docker.com/r/cyberdojo/starter-base) as its base (FROM) image.

```bash
$ ./cyber-dojo start-point create --help
  Use:
  cyber-dojo start-point create <name> --custom    <url> ...
  cyber-dojo start-point create <name> --exercises <url> ...
  cyber-dojo start-point create <name> --languages <url> ...
  ...
```
For example:
```bash
$ ./cyber-dojo start-point create \
      acme/my-languages-start-points \
        --languages \
          https://github.com/cyber-dojo-languages/csharp-nunit             \
          https://github.com/cyber-dojo-languages/gplusplus-googlemock.git \
          https://github.com/cyber-dojo-languages/java-junit.git

--languages      https://github.com/cyber-dojo-languages/csharp-nunit
--languages      https://github.com/cyber-dojo-languages/gplusplus-googlemock.git
--languages      https://github.com/cyber-dojo-languages/java-junit.git
Successfully built acme/my-languages-start-points
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
- [GET image_names())](#get-imagenames)

- - - -
# JSON in, JSON out  
* All methods receive a JSON hash.
  * The hash contains any method arguments as key-value pairs.
* All methods return a JSON hash.
  * If the method completes, a key equals the method's name.
  * If the method raises an exception, a key equals "exception".

- - - -
### GET alive?()
Useful as a liveness probe.
- returns
  * true
  ```json
    { "ready?": true }
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
