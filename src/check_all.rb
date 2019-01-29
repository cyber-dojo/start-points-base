# Detects if the start-point data contains an error.
# Run as the last line of the Dockerfile
# RUN ruby /app/src/check_all.rb /app/repos
# If this command fails and the image build fails.

require 'json'

def root_dir
  ARGV[0]
end

def shas_filename
  "#{root_dir}/shas.txt"
end

lines = `cat #{shas_filename}`.lines
puts lines
repos = Hash[lines.map { |line|
  type,index,sha,url = line.split
  [index.to_i, { type:type, sha:sha, url:url }]
}]

# For now, just printing some stuff...
repos.keys.sort.each do |key|
  type = repos[key][:type]
  puts key
  puts JSON.pretty_generate(repos[key])
  puts `ls -al #{root_dir}/#{type}/#{key}`
end
#... and always succeeding
exit(0)
