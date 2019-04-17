require_relative 'show_error'

module CheckMaxSeconds

  include ShowError

  def check_max_seconds(url, manifest_filename, json, error_code)
    if json.has_key?('max_seconds')
      max_seconds = json['max_seconds']
      exit_unless_max_seconds_is_integer(max_seconds, url, manifest_filename, error_code)
      exit_unless_max_seconds_in_range(max_seconds, url, manifest_filename, error_code)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_max_seconds_is_integer(max_seconds, url, manifest_filename, error_code)
    unless max_seconds.is_a?(Integer)
      title = 'max_seconds must be an Integer'
      key = quoted('max_seconds')
      if max_seconds.is_a?(String)
        msg = "#{key}: #{quoted(max_seconds)}"
      else
        msg = "#{key}: #{max_seconds}"
      end
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_unless_max_seconds_in_range(max_seconds, url, manifest_filename, error_code)
    unless (1..20).include?(max_seconds)
      title = 'max_seconds must be an Integer (1..20)'
      key = quoted('max_seconds')
      msg = "#{key}: #{max_seconds}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

end
