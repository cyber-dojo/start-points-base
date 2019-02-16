require_relative 'read_manifest_filenames'
require_relative 'clean_json'
require_relative 'check_no_unknown_keys_exist'
require_relative 'check_all_required_keys_exist'
require_relative 'check_image_name'
require_relative 'check_display_name'
require_relative 'check_visible_filenames'
require_relative 'check_filename_extension'
require_relative 'check_hidden_filenames'
require_relative 'check_tab_size'
require_relative 'check_max_seconds'
require_relative 'check_highlight_filenames'
require_relative 'check_progress_regexs'
require_relative 'check_display_names'
require_relative 'check_runner_choice'

class LanguageManifestChecker

  def initialize(type)
    @type = type
  end

  def check_all(root_dir)
    display_names = {}
    filenames = read_manifest_filenames(root_dir, @type)
    filenames.each do |url,filenames|
      check_one(url, filenames, display_names)
    end
    check_display_names(display_names)
  end

  private

  def check_one(url, filenames, display_names)
    filenames.each do |filename|
      json = clean_json(url, filename)
      check_no_unknown_keys_exist(url, filename, json)
      check_all_required_keys_exist(url, filename, json)
      check_required_keys(url, filename, json)
      check_optional_keys(url, filename, json)
      check_deprecated_keys(url, filename, json)
      display_name = json['display_name']
      display_names[display_name] ||= []
      display_names[display_name] << [url,filename]
    end
  end

  def check_required_keys(url, filename, json)
    check_image_name(url, filename, json)
    check_display_name(url, filename, json)
    check_visible_filenames(url, filename, json)
    check_filename_extension(url, filename, json)
  end

  def check_optional_keys(url, filename, json)
    check_hidden_filenames(url, filename, json)
    check_tab_size(url, filename, json)
    check_max_seconds(url, filename, json)
    check_highlight_filenames(url, filename, json)
    check_progress_regexs(url, filename, json)
  end

  def check_deprecated_keys(url, filename, json)
    check_runner_choice(url, filename, json)
  end

  include CleanJson
  include CheckNoUnknownKeysExist
  include CheckAllRequiredKeysExist
  include CheckImageName
  include CheckDisplayName
  include CheckVisibleFilenames
  include CheckFilenameExtension
  include CheckHiddenFilenames
  include CheckTabSize
  include CheckMaxSeconds
  include CheckHighlightFilenames
  include CheckProgressRegexs
  include CheckDisplayNames
  include CheckRunnerChoice

end
