require_relative 'show_error'

module CheckAllRequiredKeysExist

  include ShowError

  def check_all_required_keys_exist(url, filename, json)
    required_keys.each do |key|
      unless json.keys.include?(key)
        title = "missing required key \"#{key}\""
        msg = ''
        show_error(title, url, filename, msg)
        exit(20)
      end
    end
  end

  def required_keys
    %w( display_name
        visible_filenames
        image_name
        filename_extension
      )
  end

end
