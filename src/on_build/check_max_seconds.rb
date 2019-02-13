require_relative 'show_error'

module CheckMaxSeconds

  include ShowError

  def check_max_seconds(url, manifest_filename, json)
    if json.has_key?('max_seconds')
      max_seconds = json['max_seconds']
      exit_unless_max_seconds_is_integer(max_seconds, url, manifest_filename, json)
      exit_unless_max_seconds_in_range(max_seconds, url, manifest_filename, json)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_max_seconds_is_integer(max_seconds, url, manifest_filename, json)
    unless max_seconds.is_a?(Integer)
      title = 'max_seconds must be an Integer'
      if max_seconds.is_a?(String)
        msg = "\"max_seconds\": \"#{max_seconds}\""
      else
        msg = "\"max_seconds\": #{max_seconds}"
      end
      show_error(title, url, manifest_filename, msg)
      exit(44)
    end
  end

  def exit_unless_max_seconds_in_range(max_seconds, url, manifest_filename, json)
    unless (1..8).include?(max_seconds)
      title = 'max_seconds must be an Integer (1..20)'
      msg = "\"max_seconds\": #{max_seconds}"
      show_error(title, url, manifest_filename, msg)
      exit(45)
    end
  end

end
