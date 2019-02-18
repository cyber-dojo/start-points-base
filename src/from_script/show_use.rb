#!/usr/bin/ruby
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Shows help-text for the main Bash script:
#   build_cyber_dojo_start_points_image.sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def use_help_text
  script_name = File.basename(ARGV[0])
  <<~SHOW_USE

  Use:
  $ ./#{script_name} \\
      <image-name> \\
        [--custom    <git-repo-url>...]... \\
        [--exercises <git-repo-url>...]... \\
        [--languages <git-repo-url>...]...

  Creates a cyber-dojo start-point image named <image-name>.
  Its base image will be cyberdojo/start-points-base.
  It will contain checked git clones of all the specified repo-urls.

  Defaults:
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

  Example 1: local git-repo-urls

  $ ./#{script_name} \\
    acme/first-start-point \\
      --custom    file:///.../yahtzee    \\
      --exercises file:///.../katas      \\
      --languages file:///.../java-junit

  Example 2: non-local git-repo-urls

  $ ./#{script_name} \\
    acme/second-start-point \\
      --custom    https://github.com/.../my-custom.git    \\
      --exercises https://github.com/.../my-exercises.git \\
      --languages https://github.com/.../my-languages.git

  Example 3: multiple git-repo-urls for --languages

  $ ./#{script_name} \\
    acme/third-start-point \\
      --custom    file:///.../yahtzee    \\
      --exercises file:///.../katas      \\
      --languages file:///.../asm-assert \\
                  file:///.../java-junit

  Example 4: use defaults for --exercises and --languages

  $ ./#{script_name} \\
    acme/fourth-start-point \\
      --custom    file:///.../yahtzee

  Example 5: git-repo-urls from a file

  $ ./#{script_name} \\
    acme/fifth-start-point \\
      --custom    https://github.com/.../my-custom.git     \\
      --exercises https://github.com/.../my-exercises.git  \\
      --languages "$(< my-language-selection.txt)"

  $ cat my-language-selection.txt
  https://github.com/cyber-dojo-languages/java-junit
  https://github.com/cyber-dojo-languages/javascript-jasmine
  https://github.com/cyber-dojo-languages/python-pytest
  https://github.com/cyber-dojo-languages/ruby-minitest

  SHOW_USE
end

if ARGV[1] == '' || ARGV[1] == '--help'
  print(use_help_text)
  exit(0)
else
  exit(1)
end
