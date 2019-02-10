require_relative 'json_duplicate_keys'
require_relative 'show_error'
require 'json'

module CleanJson

  include JsonDuplicateKeys
  include ShowError

  def clean_json(url, filename)
    content = IO.read(filename)
    json = parse_json(url, filename, content)
    duplicates = json_duplicate_keys(content)
    if duplicates == {}
      json
    else
      msg = json_pretty_duplicate_keys(duplicates)
      title = 'duplicate keys in manifest.json file'
      show_error(title, url, filename, msg)
      exit(18)
    end
  end

  def parse_json(url, filename, content)
    JSON.parse!(content)
  rescue JSON::ParserError => error
    title = 'bad JSON in manifest.json file'
    show_error(title, url, filename, error)
    exit(17)
  end

end
