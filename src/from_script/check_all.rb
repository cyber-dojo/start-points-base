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
# Special file+dir off the root dir are:
#    custom-image =>    custom_shas.txt    custom/
# exercises-image => exercises_shas.txt exercises/
# languages-image => languages_shas.txt languages/
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require_relative 'language_manifest_checker'
require_relative 'exercise_manifest_checker'

checker = {
  'custom'    => LanguageManifestChecker.new('custom'   ),
  'exercises' => ExerciseManifestChecker.new('exercises'),
  'languages' => LanguageManifestChecker.new('languages')
}[ENV['SERVER_TYPE']]

root_dir = ARGV[0] # /app/repos
checker.check_all(root_dir)
exit(0)
