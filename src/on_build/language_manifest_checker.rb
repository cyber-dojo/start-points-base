require_relative 'read_manifest_filenames'
require 'json'

class LanguageManifestChecker

  def initialize(root_dir, type)
    @manifest_filenames = read_manifest_filenames(root_dir, type)
    # map:key=url (string)
    # map:values=manifest_filenames (array of strings)
  end

  def check_all
    @manifest_filenames.each do |url,filenames|
      check_one(url, filenames)
    end
  end

  private

  def check_one(url, filenames)
    filenames.each do |filename|
      content = IO.read(filename)
      begin
        json = JSON.parse!(content)
      rescue JSON::ParserError => error
        exit(17)
      end
    end
  end

end
