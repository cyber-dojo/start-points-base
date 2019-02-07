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

require_relative 'language_manifest_checker'
require_relative 'exercise_manifest_checker'

def root_dir # /app/repos
  # Off this are:
  #  3 dirs: custom/ exercises/ languages/
  #  3 files: custom_shas.txt
  #           exercises_shas.txt
  #           languages_shas.txt
  ARGV[0]
end

def manifest_filenames(status, type)
  result = {}
  lines = `cat #{root_dir}/#{type}_shas.txt`.lines
  lines.each do |line|
    index,sha,url = line.split
    repo_dir_name = "#{root_dir}/#{type}/#{index}"
    manifest_filenames = Dir.glob("#{repo_dir_name}/**/manifest.json")
    if manifest_filenames == []
      STDERR.puts('ERROR: no manifest.json files in')
      STDERR.puts("--#{type} #{url}")
      exit(status)
    else
      result[url] = manifest_filenames
    end
  end
  result
end

   custom_manifest_filenames = manifest_filenames(16, 'custom')
exercises_manifest_filenames = manifest_filenames(16, 'exercises')
languages_manifest_filenames = manifest_filenames(16, 'languages')

LanguageManifestChecker.new(   custom_manifest_filenames).check_all
ExerciseManifestChecker.new(exercises_manifest_filenames).check_all
LanguageManifestChecker.new(languages_manifest_filenames).check_all

exit(0)
