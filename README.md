
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

  The created image (sinatra based) will http-serve (copies of) the start-points in the urls when named 
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
### GET alive()
- returns
  * true (useful as a liveness probe)
- parameters
  * none
- example
  ```bash
  docker run --detach -p 80:4524 acme/my-languages-start-points:f7d51d0
  curl -X GET 0.0.0.0:80/alive
  ```
  ```json
  { "alive?": true }
  ```


- - - -
### GET ready()
- returns
  * true if the service is ready
  * false if the service is not ready
- parameters
  * none
- example
  ```bash
  docker run --detach -p 80:4524 acme/my-languages-start-points:f7d51d0
  curl -X GET 0.0.0.0:80/ready
  ```
  ```json
  { "ready?": true }
  ```

- - - -
### GET sha()
- returns
  * The 40 character git commit sha used to create the docker image.
- parameters
  * none
- example
  ```bash
  docker run --detach -p 80:4524 acme/my-languages-start-points:f7d51d0
  curl -X GET 0.0.0.0:80/sha
  ```
  ```json
  { "sha": "76dd1cabf82aa624a1dabe194731b3cd18aae36a" }
  ```

- - - -
### GET names()
- returns
  * The display_name's from all manifests.
- parameters
  * none
- example
  ```bash
  docker run --detach -p 80:4524 acme/my-languages-start-points:f7d51d0
  curl -X GET 0.0.0.0:80/names | jq .
  ```
  ```json
  {
    "names": [
      "C#, NUnit",
      "C++ (g++), GoogleMock",
      "Java 21, JUnit 5"
    ]
  }
  ```

- - - -
### GET manifests()
- returns
  * All the start-point manifests.
- parameters
  * none
- example
  ```bash
  docker run --detach -p 80:4524 acme/my-languages-start-points:f7d51d0
  curl -X GET 0.0.0.0:80/manifests | jq .
  ```
  ```json
  {
    "manifests": {
      "C#, NUnit": {
        "image_name": "cyberdojofoundation/csharp_nunit:1452bb7",
        "display_name": "C#, NUnit",
        "filename_extension": [".cs"],
        "max_seconds": 10,
        "tab_size": 4,
        "visible_files": {}
        }
      },
      "C++ (g++), GoogleMock": {
        "image_name": "cyberdojofoundation/gpp_googlemock:129f26f",
        "display_name": "C++ (g++), GoogleMock",
        "filename_extension": [".cpp", ".hpp", ".c", ".h"],
        "max_seconds": 15,
        "tab_size": 4,
        "visible_files": {}
        }
      },
      "Java 21, JUnit 5": {
        "image_name": "cyberdojofoundation/java_junit:edf2565",
        "display_name": "Java 21, JUnit 5",
        "filename_extension": [".java"],
        "max_seconds": 10,
        "tab_size": 4,
        "progress_regexs": [
          "Failures (\\d)\\:",
          "^\\[\\s+(\\d+) tests successful\\s+\\]"
        ],
        "visible_files": {}
      }
    }
  }
  ```

- - - -
### GET manifest(name)
- returns
  * The manifest for the given name.
- parameters
  * **name:String** from a previous call to the names method above
- example
  ```bash
  docker run --detach -p 80:4524 acme/my-languages-start-points:f7d51d0
  curl -d '{"name":"C#, NUnit"}' -X GET 0.0.0.0:80/manifest | jq .
  ```
  ```json
  { "manifest": {
        "display_name": "C#, NUNit",
        "image_name": "cyberdojofoundation/csharp_nunit:1452bb7",
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

- - - -
### GET image_names()
- returns
  * The image_names from all manifests.
- parameters
  * none
- example
  ```bash 
  docker run --detach -p 80:4524 acme/my-languages-start-points:f7d51d0
  curl -X GET 0.0.0.0:80/image_names | jq .
  ```
  ```json
    { "image_names": [
        "cyberdojofoundation/csharp_nunit:1452bb7",
        "cyberdojofoundation/python_unittest:51c7d93",
        "cyberdojofoundation/ruby_mini_test:a074c0a"
      ]
    }
  ```

- - - -

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
