require_relative 'json_duplicate_keys'
require_relative 'show_error'
require 'json'

module CleanJson

  include JsonDuplicateKeys
  include ShowError

  def clean_json(url, filename)
    content = IO.read(filename)
    parsed = JSON.parse!(content)
    # json_duplicate_keys() could raise so it is important it is called after parse_json()
    duplicates = json_duplicate_keys(content)
    if duplicates === []
      parsed
    else
      title = 'duplicate keys in manifest.json file'
      show_error(title, url, filename, duplicates.to_s)
      exit(18)
    end
  rescue JSON::ParserError, JSON::Stream::ParserError => error
    title = 'bad JSON in manifest.json file'
    show_error(title, url, filename, error.to_s)
    exit(17)
  end

end
