require_relative 'show_error'

module CheckDisplayNameIsValid

  include ShowError

  def check_display_name_is_valid(url, filename, json)
    display_name = json['display_name']
    unless display_name.is_a?(String)
      title = 'display_name is not a String'
      msg = "\"display_name\": #{display_name}"
      show_error(title, url, filename, msg)
      exit(23)
    end
    unless display_name.size > 0
      title = 'display_name is empty'
      msg = '"display_name": ""'
      show_error(title, url, filename, msg)
      exit(24)
    end
  end

end
