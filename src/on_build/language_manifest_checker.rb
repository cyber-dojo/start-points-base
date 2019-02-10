require_relative 'read_manifest_filenames'
require_relative 'clean_json'
require_relative 'check_no_unknown_keys_exist'
require_relative 'check_all_required_keys_exist'

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
  include CheckAllRequiredKeysExist

  def check_one(url, filenames)
    filenames.each do |filename|
      json = clean_json(url, filename)
      check_no_unknown_keys_exist(url, filename, json)
      check_all_required_keys_exist(url, filename, json)
      # required-keys
      #check_image_name_is_valid
      #check_display_name_is_valid
      #check_visible_filenames_is_valid

    end
  end

end
