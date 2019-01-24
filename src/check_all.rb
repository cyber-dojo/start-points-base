require 'json'

def root_dir
  ARGV[0]
end

def shas_filename
  "#{root_dir}/shas.txt"
end

lines = `cat #{shas_filename}`.lines
repos = Hash[lines.map { |line|
  type,index,sha,url = line.split
  [index, { type:type, sha:sha, url:url }]
}]

repos.keys.sort.each do |key|
  type = repos[key][:type]
  puts key
  puts JSON.pretty_generate(repos[key])
  puts `ls -al #{root_dir}/#{type}/#{key}`
end
