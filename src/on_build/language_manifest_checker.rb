require_relative 'read_manifest_filenames'
require_relative 'clean_json'

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

  def check_one(url, filenames)
    filenames.each do |filename|
      json = clean_json(url, filename)
      check_no_unknown_keys_exist(url, filename, json)
    end
  end

  def check_no_unknown_keys_exist(url, filename, json)
    json.keys.each do |key|
      unless known_keys.include?(key)
        STDERR.puts('ERROR: unknown key in manifest.json file')
        STDERR.puts("--#{@type} #{url}")
        STDERR.puts("filename='#{relative(filename)}'")
        STDERR.puts("key=\"#{key}\"")
        exit(19)        
      end
    end
  end

  def known_keys
    %w( display_name
        visible_filenames
        hidden_filenames
        image_name
        runner_choice
        filename_extension
        highlight_filenames
        progress_regexs
        tab_size
        max_seconds
      )
  end

end
