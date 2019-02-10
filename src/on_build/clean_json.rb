require_relative 'json_duplicate_keys'
require 'json'

module CleanJson

  include JsonDuplicateKeys

  def clean_json(url, filename)
    content = IO.read(filename)
    json = parse_json(url, filename, content)
    duplicates = json_duplicate_keys(content)
    if duplicates == {}
      json
    else
      msg = json_pretty_duplicate_keys(duplicates)
      STDERR.puts('ERROR: duplicate keys in manifest.json file')
      STDERR.puts("--#{@type} #{url}")
      STDERR.puts("manifest='#{relative(filename)}'")
      STDERR.puts(msg)
      exit(18)
    end
  end

  def parse_json(url, filename, content)
    JSON.parse!(content)
  rescue JSON::ParserError => error
    STDERR.puts('ERROR: bad JSON in manifest.json file')
    STDERR.puts("--#{@type} #{url}")
    STDERR.puts("manifest='#{relative(filename)}'")
    STDERR.puts(error)
    exit(17)
  end

  def relative(filename)
    # eg '/app/repos/languages/3/languages-python-unittest/start_point/manifest.json'
    parts = filename.split('/')
    parts[5..-1].join('/')
    # eg 'languages-python-unittest/start_point/manifest.json'
  end

end
