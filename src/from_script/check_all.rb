#!/usr/bin/ruby
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Detects faults in the start-point files git-cloned from
# the urls specified as arguments to the main Bash script:
#   build_cyber_dojo_start_points_image.sh
# which runs a [docker image build] whose Dockerfile's has
# RUN /app/src/from_script/check_all.rb /app/repos $(image_type)
# Thus, if this Ruby script returns a non-zero exit status
# the [docker build] fails and the main Bash script fails
# to build a docker image.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require_relative 'language_manifest_checker'
require_relative 'exercise_manifest_checker'

def root_dir
  ARGV[0] # /app/repos
end

def image_type
  ARGV[1] # 'custom|exercises|languages'
end

checker = case image_type
when 'custom'    then LanguageManifestChecker.new(image_type)
when 'exercises' then ExerciseManifestChecker.new(image_type)
when 'languages' then LanguageManifestChecker.new(image_type)
end

checker.check_all(root_dir)
exit(0)
