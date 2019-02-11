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
LanguageManifestChecker.new('custom'   ).check_all(root_dir)
ExerciseManifestChecker.new('exercises').check_all(root_dir)
LanguageManifestChecker.new('languages').check_all(root_dir)
exit(0)
