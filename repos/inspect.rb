require 'json'

root_dir = '/app/repos'
json = {}
lines = `cat #{root_dir}/shas.txt`.lines
lines.each do |line|
  index,sha,url = line.split
  repo_dir_name = "#{root_dir}/#{index}"
  manifest_filenames = Dir.glob("#{repo_dir_name}/**/manifest.json")
  manifest_filenames.each do |manifest_filename|
    content = IO.read(manifest_filename)
    manifest = JSON.parse!(content)
    display_name = manifest['display_name']
    image_name = manifest['image_name']
    json[display_name] = {
      'url' => url, 
      'sha' => sha,
      'image_name' => image_name
    }
  end
end
puts JSON.pretty_generate(json)