require 'json'

def root_dir
  ARGV[0]
end

def shas_filename
  "#{root_dir}/shas.txt"
end

lines = `cat #{shas_filename}`.lines
repos = Hash[lines.map { |line|
  index,sha,url = line.split
  [index, { sha:sha, url:url }]
}]

repos.keys.sort.each do |key|
  puts key
  puts JSON.pretty_generate(repos[key])
  puts `ls -al #{root_dir}/#{key}`
end

# TODO:
# starting moving commander's start-point checking code
# to here, with tests.
