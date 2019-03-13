require_relative 'read_manifest_filenames'
require_relative 'clean_json'
require_relative 'check_no_unknown_keys_exist'
require_relative 'check_all_required_keys_exist'
require_relative 'check_display_name'
require_relative 'check_display_names'
require_relative 'check_visible_filenames'

class ExerciseManifestChecker

  def initialize(type)
    @type = type
  end

  def check_all(root_dir)
    display_names = {}
    filenames = read_manifest_filenames(root_dir, @type, 16)
    filenames.each do |url,filenames|
      check_one(url, filenames, display_names)
    end
    check_display_names(display_names, 90)
  end

  private

  include ReadManifestFilenames
  include CleanJson
  include CheckNoUnknownKeysExist
  include CheckAllRequiredKeysExist
  include CheckDisplayName
  include CheckDisplayNames
  include CheckVisibleFilenames

  def check_one(url, filenames, display_names)
    filenames.each do |filename|
      json = clean_json(url, filename)
      check_no_unknown_keys_exist(known_keys, url, filename, json, 50)
      check_all_required_keys_exist(required_keys, url, filename, json, 51)
      check_required_keys(url, filename, json)
      # optional 70
      # deprecated 80
      display_name = json['display_name']
      display_names[display_name] ||= []
      display_names[display_name] << [url,filename]
    end
  end

  def check_required_keys(url, filename, json)
    check_display_name(url, filename, json, 60)
    check_visible_filenames(url, filename, json, 61)
  end

  def known_keys
    %w( display_name
        visible_filenames
      )
  end

  def required_keys
    %w( display_name
        visible_filenames
      )
  end

end
