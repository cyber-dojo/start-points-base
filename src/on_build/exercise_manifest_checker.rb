require_relative 'read_manifest_filenames'
require_relative 'clean_json'
require_relative 'check_no_unknown_keys_exist'
require_relative 'check_all_required_keys_exist'

class ExerciseManifestChecker

  def initialize(type)
    @type = type
  end

  def check_all(root_dir)
    display_names = {}
    filenames = read_manifest_filenames(root_dir, @type)
    filenames.each do |url,filenames|
      check_one(url, filenames, display_names)
    end
  end

  private

  include CleanJson
  include CheckNoUnknownKeysExist
  include CheckAllRequiredKeysExist

  def check_one(url, filenames, display_names)
    filenames.each do |filename|
      json = clean_json(url, filename)
      check_no_unknown_keys_exist(known_keys, url, filename, json, 50)
      check_all_required_keys_exist(required_keys, url, filename, json, 51)
      #display_name = json['display_name']
      #display_names[display_name] ||= []
      #display_names[display_name] << [url,filename]
    end
  end

  def known_keys
    %w( display_name
      )
  end

  def required_keys
    %w( display_name
      )
  end

end
