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

require 'json'

def root_dir
  # Set to /app/repos
  # Off this are 3 dirs and one file
  # custom/
  # exercises/
  # languages/
  # shas.txt
  ARGV[0]
end

def shas_filename
  "#{root_dir}/shas.txt"
end

def repos
  lines = `cat #{shas_filename}`.lines
  Hash[lines.map { |line|
    type,url,sha,index = line.split
    [index.to_i, { type:type, url:url, sha:sha }]
  }]
end

def show_repos
  repos.keys.sort.each do |key|
    type = repos[key][:type]
    puts(key)
    puts(JSON.pretty_generate(repos[key]))
    puts(`ls -al #{root_dir}/#{type}/#{key}`)
  end
end

Dir.glob("#{root_dir}/languages/*").each do |dir_name|
  manifest_filenames = Dir.glob("#{dir_name}/**/manifest.json")
  if manifest_filenames == []
    index = File.basename(dir_name).to_i
    url = repos[index][:url]
    STDERR.puts('ERROR: no manifest.json files')
    STDERR.puts("--languages #{url}")
    exit(1)
  end
end

# TODO: need to check _each_ custom repo
manifest_filenames = Dir.glob("#{root_dir}/custom/**/manifest.json")
if manifest_filenames == []
  STDERR.puts("ERROR: no --custom manifest.json files")
  exit(2)
end


exit(0)
