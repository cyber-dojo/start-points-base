#!/usr/bin/ruby
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Detects faults in the start-point files git-cloned from
# the urls specified as arguments to the main Bash script:
#   build_cyber_dojo_start_points_image.sh
# which runs a [docker image build] whose Dockerfile's
# FROM image contains a call to _this_ Ruby script
#   ONBUILD RUN /app/src/onbuild/check_all.rb /app/repos
# Thus, if this Ruby script returns a non-zero exit status
# the [docker build] fails and the main Bash script fails
# to build a docker image.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Off root_dir are:
#  3 dirs: custom/ exercises/ languages/
#  3 files: custom_shas.txt
#           exercises_shas.txt
#           languages_shas.txt
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require_relative 'language_manifest_checker'
require_relative 'exercise_manifest_checker'

root_dir = ARGV[0] # /app/repos
LanguageManifestChecker.new(root_dir, 'custom'   ).check_all
ExerciseManifestChecker.new(root_dir, 'exercises').check_all
LanguageManifestChecker.new(root_dir, 'languages').check_all
exit(0)
