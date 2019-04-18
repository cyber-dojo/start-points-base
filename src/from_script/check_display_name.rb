require_relative 'show_error'

module CheckDisplayName

  include ShowError

  def check_display_name(url, filename, json, error_code)
    ok = json['display_name']
    ok &&= check_display_name_is_string(url, filename, json, error_code)
    ok &&= check_display_name_is_non_empty(url, filename, json, error_code)
  end

  # - - - - - - - - - - - - - - - - - -

  def check_display_name_is_string(url, filename, json, error_code)
    result = true
    display_name = json['display_name']
    unless display_name.is_a?(String)
      title = 'display_name is not a String'
      key = quoted('display_name')
      msg = "#{key}: #{display_name}"
      result = error(title, url, filename, msg, error_code)
    end
    result
  end

  def check_display_name_is_non_empty(url, filename, json, error_code)
    display_name = json['display_name']
    unless display_name.size > 0
      title = 'display_name cannot be empty String'
      msg = '"display_name": ""'
      error(title, url, filename, msg, error_code)
    end
  end

end
