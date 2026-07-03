require 'json'
require 'uri'
require_relative '../src/starter'

# Rewrites a file:/// url to a plain file:// url with an absolute path.
def clean_url(url)
  if url.start_with?('file:///')
    url = URI(url)
    'file://' + File.expand_path(url.path)
  else
    url
  end
end

# The kind of start-point this image holds: custom, exercises, or languages.
def image_type
  ENV['IMAGE_TYPE']
end

# Reads every manifest under root_dir (one repo per shas.txt line, each repo
# possibly holding several manifest.json files) and returns two aligned arrays:
# the parsed manifests, and a {sha,url} metadata hash for each.
def read_manifests(root_dir)
  manifests = []
  metadatas = []
  lines = `cat #{root_dir}/shas.txt`.lines
  lines.each do |line|
    index, sha, url = line.split
    repo_dir_name = "#{root_dir}/#{index}"
    Dir.glob("#{repo_dir_name}/**/manifest.json").each do |manifest_filename|
      manifests << JSON.parse!(IO.read(manifest_filename))
      metadatas << { 'sha' => sha, 'url' => clean_url(url) }
    end
  end
  [manifests, metadatas]
end

root_dir = '/app/repos'
manifests, metadatas = read_manifests(root_dir)

# Reuse the same display-name construction the languages/exercises server uses
# (Starter.names_for): when every manifest carries a language and a
# test_framework [name,version] pair AND the constructed "language,
# test_framework" names are unique, the version is dropped from the name;
# otherwise each manifest keeps its raw display_name. This keeps the names
# emitted here consistent with the server's /manifests endpoint. The separate
# language/test_framework arrays are also emitted so no version information is
# lost when the name is de-versioned.
names = Starter.names_for(manifests)

json = {}
manifests.each_with_index do |manifest, i|
  entry = {
    'url' => metadatas[i]['url'],
    'sha' => metadatas[i]['sha']
  }
  unless image_type == 'exercises'
    entry['image_name'] = manifest['image_name']
  end
  entry['language'] = manifest['language'] if manifest.key?('language')
  entry['test_framework'] = manifest['test_framework'] if manifest.key?('test_framework')
  json[names[i]] = entry
end

puts JSON.pretty_generate(Hash[*json.sort.flatten])
