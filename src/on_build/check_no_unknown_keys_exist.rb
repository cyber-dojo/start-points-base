require_relative 'show_error'

module CheckNoUnknownKeysExist

  include ShowError

  def check_no_unknown_keys_exist(url, filename, json, error_code)
    json.keys.each do |key|
      unless known_keys.include?(key)
        title = "unknown key \"#{key}\""
        show_error(title, url, filename)
        exit(error_code)
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
