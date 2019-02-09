require_relative 'read_manifest_filenames'
require_relative 'json_duplicate_keys'
require 'json'

class LanguageManifestChecker

  def initialize(root_dir, type)
    @type = type
    @manifest_filenames = read_manifest_filenames(root_dir, type)
  end

  def check_all
    @manifest_filenames.each do |url,filenames|
      check_one(url, filenames)
    end
  end

  private

  include JsonDuplicateKeys

  def check_one(url, filenames)
    filenames.each do |filename|
      content = IO.read(filename)
      json = clean_json(url, filename, content)
      #...
    end
  end

  def clean_json(url, filename, content)
    json = parse_json(url, filename, content)
    duplicates = json_duplicate_keys(content)
    if duplicates == {}
      json
    else
      msg = json_pretty_duplicate_keys(duplicates)
      STDERR.puts('ERROR: duplicate keys in manifest.json file')
      STDERR.puts("--#{@type} #{url}")
      STDERR.puts("filename='#{filename}'")
      STDERR.puts(msg)
      exit(18)
    end
  end

  def parse_json(url, filename, content)
    JSON.parse!(content)
  rescue JSON::ParserError => error
    STDERR.puts('ERROR: bad JSON in manifest.json file')
    STDERR.puts("--#{@type} #{url}")
    STDERR.puts("filename='#{filename}'")
    STDERR.puts(error)
    exit(17)
  end

end
