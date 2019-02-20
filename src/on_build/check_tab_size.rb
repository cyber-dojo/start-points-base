require_relative 'show_error'

module CheckTabSize

  include ShowError

  def check_tab_size(url, manifest_filename, json, error_code)
    if json.has_key?('tab_size')
      tab_size = json['tab_size']
      exit_unless_tab_size_is_integer(tab_size, url, manifest_filename, json, error_code)
      exit_unless_tab_size_in_range(tab_size, url, manifest_filename, json, error_code)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_tab_size_is_integer(tab_size, url, manifest_filename, json, error_code)
    unless tab_size.is_a?(Integer)
      title = 'tab_size must be an Integer'
      if tab_size.is_a?(String)
        msg = "\"tab_size\": \"#{tab_size}\""
      else
        msg = "\"tab_size\": #{tab_size}"
      end
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_unless_tab_size_in_range(tab_size, url, manifest_filename, json, error_code)
    unless (1..8).include?(tab_size)
      title = 'tab_size must be an Integer (1..8)'
      msg = "\"tab_size\": #{tab_size}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

end
