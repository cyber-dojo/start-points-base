require 'json'
require 'uri'

def clean_url(url)
  if url.start_with?('file:///')
    url = URI(url)
    'file://' + File.expand_path(url.path)
  else
    url
  end
end

def image_type
  ENV['IMAGE_TYPE']
end

root_dir = '/app/repos'
json = {}
lines = `cat #{root_dir}/build.shas`.lines
lines.each do |line|
  index,sha,url = line.split
  tag = sha[0...7]
  repo_dir_name = "#{root_dir}/#{index}"
  manifest_filenames = Dir.glob("#{repo_dir_name}/**/manifest.json")
  manifest_filenames.each do |manifest_filename|
    content = IO.read(manifest_filename)
    manifest = JSON.parse!(content)
    display_name = manifest['display_name']
    json[display_name] = {
      'url' => clean_url(url),
      'sha' => sha
    }
    unless image_type == 'exercises'
      json[display_name]['image_name'] = manifest['image_name']+':'+tag
    end
  end
end
puts JSON.pretty_generate(Hash[*json.sort.flatten])
