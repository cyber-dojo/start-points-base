require_relative 'read_manifest_filenames'
require_relative 'clean_json'
require_relative 'check_no_unknown_keys_exist'
require_relative 'check_all_required_keys_exist'
require_relative 'check_image_name_is_valid'
require_relative 'check_display_name_is_valid'

class LanguageManifestChecker

  def initialize(type)
    @type = type
  end

  def check_all(root_dir)
    filenames = read_manifest_filenames(root_dir, @type)
    filenames.each do |url,filenames|
      check_one(url, filenames)
    end
  end

  private

  include CleanJson
  include CheckNoUnknownKeysExist
  include CheckAllRequiredKeysExist
  include CheckImageNameIsValid
  include CheckDisplayNameIsValid

  def check_one(url, filenames)
    filenames.each do |filename|
      json = clean_json(url, filename)
      check_no_unknown_keys_exist(url, filename, json)
      check_all_required_keys_exist(url, filename, json)
      # required-keys
      check_image_name_is_valid(url, filename, json)
      check_display_name_is_valid(url, filename, json)
      #check_visible_filenames_is_valid(url, filename, json)
      #check_filename_extension_is_valid(url, filename, json)
      # optional-keys
      #check_hidden_filenames_is_valid(url, filename, json)
      #check_highlight_filenames_is_valid(url, filename, json)
      #check_progress_regexs_is_valid(url, filename, json)
      #check_tab_size_is_valid(url, filename, json)
      #check_max_seconds_is_valid(url, filename, json)
      # deprecated-keys
      #check_runner_choice(url, filename, json)
    end
    #check_display_names_are_unique
  end

end
