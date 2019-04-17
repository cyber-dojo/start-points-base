require_relative 'show_error'

module CheckMaxSeconds

  include ShowError

  def check_max_seconds(url, manifest_filename, json, error_code)
    if json.has_key?('max_seconds')
      max_seconds = json['max_seconds']
      ok = max_seconds_is_integer(max_seconds, url, manifest_filename, error_code)
      ok && max_seconds_in_range(max_seconds, url, manifest_filename, error_code)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def max_seconds_is_integer(max_seconds, url, manifest_filename, error_code)
    result = true
    unless max_seconds.is_a?(Integer)
      title = 'max_seconds must be an Integer'
      key = quoted('max_seconds')
      if max_seconds.is_a?(String)
        msg = "#{key}: #{quoted(max_seconds)}"
      else
        msg = "#{key}: #{max_seconds}"
      end
      result = error(title, url, manifest_filename, msg, error_code)
    end
    result
  end

  def max_seconds_in_range(max_seconds, url, manifest_filename, error_code)
    unless (1..20).include?(max_seconds)
      title = 'max_seconds must be an Integer (1..20)'
      key = quoted('max_seconds')
      msg = "#{key}: #{max_seconds}"
      error(title, url, manifest_filename, msg, error_code)
    end
  end

end
