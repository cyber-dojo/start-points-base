require_relative 'read_manifest_filenames'
require_relative 'clean_json'
require_relative 'check_no_unknown_keys_exist'

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

  include CleanJson
  include CheckNoUnknownKeysExist

  def check_one(url, filenames)
    filenames.each do |filename|
      json = clean_json(url, filename)
      check_no_unknown_keys_exist(url, filename, json)
    end
  end

end
