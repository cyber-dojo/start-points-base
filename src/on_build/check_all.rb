# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ruby script to detect faults in the start-point data
# git-cloned from the git-repo-urls specified as arguments
# to the main Bash script
#   build_cyber_dojo_start_points_image.sh
#
# The main Bash script runs a [docker build] command using
# a generated Dockerfile written to a temporary context dir
# The generated Dockerfile's base (FROM) image contains a
# call to this Ruby script
#   ONBUILD RUN ruby /app/src/onbuild/check_all.rb /app/repos
#
# Thus, if this Ruby script returns a non-zero exit status
# the [docker build] fails and the main Bash script fails to
# build a docker image.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require 'json'

def root_dir # /app/repos
  # Off this are:
  #  3 dirs: custom/ exercises/ languages/
  #  3 files: custom_shas.txt exercises_shas.txt languages_shas.txt
  ARGV[0]
end

def manifest_filenames(type)
  lines = `cat #{root_dir}/#{type}_shas.txt`.lines
  r = Hash[lines.map { |line|
    index,sha,url = line.split
    [index.to_i, { sha:sha, url:url }]
  }]
  result = []
  r.each do |index,values|
    dir_name = "#{root_dir}/#{type}/#{index}"
    manifest_filenames = Dir.glob("#{dir_name}/**/manifest.json")
    if manifest_filenames == []
      STDERR.puts('ERROR: no manifest.json files in')
      STDERR.puts("--#{type} #{values[:url]}")
      exit(1)
    else
      result += manifest_filenames
    end
  end
  result
end

   custom_manifest_filenames = manifest_filenames('custom')
exercises_manifest_filenames = manifest_filenames('exercises')
languages_manifest_filenames = manifest_filenames('languages')

exit(0)
