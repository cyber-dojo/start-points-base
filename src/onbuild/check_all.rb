# The job of this Ruby script is to detect faults in the
# start-point data git-cloned from the git-repo-urls
# specified as arguments to the main Bash script
#   build_cyber_dojo_start_points_image.sh
# The main Bash script runs a [docker build] command
# using a generated Dockerfile written to a temporary
# context dir. The last line of this Dockerfile is
#   RUN ruby /app/src/check_all.rb /app/repos
# Thus, if this Ruby script returns a non-zero exit status
# the [docker build] fails and the main Bash script
# fails to build a docker image.

require 'json'

def root_dir
  ARGV[0]
end

def shas_filename
  "#{root_dir}/shas.txt"
end

def print(s)
  #puts s
end

lines = `cat #{shas_filename}`.lines
repos = Hash[lines.map { |line|
  type,url,sha,index = line.split
  [index.to_i, { type:type, url:url, sha:sha }]
}]

# For now, just printing some stuff...
repos.keys.sort.each do |key|
  type = repos[key][:type]
  print(key)
  print(JSON.pretty_generate(repos[key]))
  print(`ls -al #{root_dir}/#{type}/#{key}`)
end
#... and always succeeding
exit(0)
