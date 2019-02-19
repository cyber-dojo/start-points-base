
<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png" alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

New starter architecture (currently live on https://beta.cyber-dojo.org only)
[![CircleCI](https://circleci.com/gh/cyber-dojo/start-points-base.svg?style=svg)](https://circleci.com/gh/cyber-dojo/start-points-base)

The source for the [cyberdojo/start-points-base](https://hub.docker.com/r/cyberdojo/start-points-base) docker image.
* Use the [build_cyber_dojo_start_points_image.sh](../build_cyber_dojo_start_point_image.sh)
script to create your cyber-dojo start-point docker image.
* It will use cyberdojo/start-points-base as its base (FROM) image.
* The first argument is the name of the docker image you want to create.
* The subsequent arguments are git-cloneable URLs containing the source for the start points.

```bash
$ ./build_cyber_dojo_start_points_image.sh --help
Use: ./build_cyber_dojo_start_points_image.sh \
         <image-name> \
           [--custom    <git-repo-url>...]... \
           [--exercises <git-repo-url>...]... \
           [--languages <git-repo-url>...]... \
...
```
For example:
```bash
$ ./build_cyber_dojo_start_points_image.sh \
      acme/my-start-points \
        --custom \
          https://github.com/cyber-dojo/start-points-custom.git \
        --exercises \
          https://github.com/cyber-dojo/start-points-exercises.git \
        --languages \
          https://github.com/cyber-dojo-languages/csharp-nunit         \
          https://github.com/cyber-dojo-languages/gplusplus-googlemock \
          https://github.com/cyber-dojo-languages/java-junit
```
Default git-repo-urls:
```bash
  --custom
    https://github.com/cyber-dojo/start-points-custom.git
  --exercises
    https://github.com/cyber-dojo/start-points-exercises.git
  --languages
    https://github.com/cyber-dojo-languages/csharp-nunit
    https://github.com/cyber-dojo-languages/gcc-googletest
    https://github.com/cyber-dojo-languages/gplusplus-googlemock
    https://github.com/cyber-dojo-languages/java-junit
    https://github.com/cyber-dojo-languages/javascript-jasmine
    https://github.com/cyber-dojo-languages/python-pytest
    https://github.com/cyber-dojo-languages/ruby-minitest
```

There are 2 kinds of start-points
- languages/custom...
- exercises...

- - - -

- A docker-containerized micro-service for [cyber-dojo](http://cyber-dojo.org).
- Holds the start-points used when setting up a practice session.

API:
  * All methods receive their named arguments in a json hash.
  * All methods return a json hash.
    * If the method completes, a key equals the method's name.
    * If the method raises an exception, a key equals "exception".

#
- [GET ready?()](#get-ready)
- [GET sha()](#get-sha)
#
- [GET language_start_points()](#get-language_start_points)
- [GET language_manifest(display_name,exercise_name)](#get-language_manifestdisplay_nameexercise_name)
#
- [GET custom_start_points()](#get-custom_start_points)
- [GET custom_manifest(display_name)](#get-custom_manifestdisplay_name)

- - - -

## GET ready?()
- parameters, none
```
  {}
```
- returns true if the service is ready, otherwise false, eg
```
  { "ready?": true }
  { "ready?": false }
```

- - - -

## GET sha()
Returns the git commit sha used to create the docker image.
- parameters, none
```
  {}
```
- returns the sha, eg
```
  { "sha": "b28b3e13c0778fe409a50d23628f631f87920ce5" }
```

- - - -

## GET language_start_points()
- parameters, none
```
  {}
```
- returns two arrays; the language-test-framework display_names and the exercises names, eg
```
  { "language_start_points": {
      "languages": [
        "C (gcc), assert",
        "C#, NUnit",
        "C++ (g++), assert",
        "Python, py.test",
        "Python, unittest"
      ],
      "exercises": [
        "Bowling_Game",
        "Fizz_Buzz",
        "Leap_Years",
        "Tiny_Maze"
      ]
    }
  }
```

- - - -

## GET language_manifest(display_name,exercise_name)
- parameters, display_name and exercise_name from a previous call to
the language_start_points method above, eg
```
  {  "display_name": "C#, NUnit",
     "exercise_name": "Fizz_Buzz"
  }
```
- returns, the manifest for the given display_name
and the exercise instructions text for the given exercise_name, eg
```
  { "language_manifest": {
       "manifest": {
          "display_name": "C#, NUNit",
          "image_name": "cyberdojofoundation/csharp_nunit",
          "filename_extension": [ ".cs" ],
          "visible_files": {
             "Hiker.cs": {               
               "content" => "public class Hiker..."
             },
             "HikerTest.cs": {
               "content" => "using NUnit.Framework;..."
             },
             "cyber-dojo.sh": {
               "content" => "NUNIT_PATH=/nunit/lib/net45..."
             }
          }
       },
       "exercise": "Write a program that prints..."
    }
  }
```

- - - -

## GET custom_start_points()
- parameters, none
```
  {}
```
- returns an array of the custom start-point display_names, eg
```
  { "custom_start_points": [
      "Yahtzee refactoring, C# NUnit",
      "Yahtzee refactoring, C++ (g++) assert",
      "Yahtzee refactoring, Java JUnit",
      "Yahtzee refactoring, Python unitttest"
    ]
  }
```

- - - -

## GET custom_manifest(display_name)
- parameter, display_name from a previous call to the custom_start_points method above, eg
```
  {  "display_name": "Yahtzee refactoring, C# NUnit"
  }
```
- returns, the manifest for the given display_name, eg
```
  { "custom_manifest": {
       "display_name": "Yahtzee refactoring, C# NUnit",
       "image_name": "cyberdojofoundation/csharp_nunit",
       "filename_extension": [ ".cs" ],
       "visible_files": {
          "Yahtzee.cs": {
            "content"= > "public class Yahtzee {..."
          },
          "YahtzeeTest.cs": {
            "content"= > "using NUnit.Framework;..."
          },
          "cyber-dojo.sh": {
            "content"= > "NUNIT_PATH=/nunit/lib/net45..."
          }
          "instructions": {
            "content"= > "The starting code..."
          }
       }
    }
  }
```

- - - -

* [Take me to cyber-dojo's home github repo](https://github.com/cyber-dojo/cyber-dojo).
* [Take me to the http://cyber-dojo.org site](http://cyber-dojo.org).

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
