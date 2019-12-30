require_relative 'show_error'

module CheckTabSize

  include ShowError

  def check_tab_size(url, manifest_filename, json, error_code)
    if json.has_key?('tab_size')
      ok = tab_size_is_integer(url, manifest_filename, json, error_code)
      ok && tab_size_in_range(url, manifest_filename, json, error_code)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def tab_size_is_integer(url, manifest_filename, json, error_code)
    result = true
    tab_size = json['tab_size']
    unless tab_size.is_a?(Integer)
      title = 'tab_size must be an Integer'
      key = quoted('tab_size')
      if tab_size.is_a?(String)
        msg = "#{key}: \"#{tab_size}\""
      else
        msg = "#{key}: #{tab_size}"
      end
      result = error(title, url, manifest_filename, msg, error_code)
    end
    result
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def tab_size_in_range(url, manifest_filename, json, error_code)
    tab_size = json['tab_size']
    unless (1..8).include?(tab_size)
      title = 'tab_size must be an Integer (1..8)'
      key = quoted('tab_size')
      msg = "#{key}: #{tab_size}"
      error(title, url, manifest_filename, msg, error_code)
    end
  end

end
