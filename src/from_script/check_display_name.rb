require_relative 'show_error'

module CheckDisplayName

  include ShowError

  def check_display_name(url, filename, json, error_code)
    display_name = json['display_name']
    unless display_name.is_a?(String)
      title = 'display_name is not a String'
      key = quoted('display_name')
      msg = "#{key}: #{display_name}"
      show_error(title, url, filename, msg)
      exit(error_code)
    end
    unless display_name.size > 0
      title = 'display_name is empty'
      msg = '"display_name": ""'
      show_error(title, url, filename, msg)
      exit(error_code)
    end
  end

end
