require_relative 'show_error'

module CheckNoUnknownKeysExist

  include ShowError

  def check_no_unknown_keys_exist(url, filename, json)
    json.keys.each do |key|
      unless known_keys.include?(key)
        title = 'unknown key in manifest.json file'
        msg = "key=\"#{key}\""
        show_error(title, url, filename, msg)
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
