require_relative 'show_error'

module CheckVisibleFilenamesIsValid

  include ShowError

  def check_visible_filenames_is_valid(url, filename, json)
    visible_filenames = json['visible_filenames']
    unless visible_filenames.is_a?(Array)
      title = 'visible_filenames is not an Array'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, filename, msg)
      exit(25)
    end
    unless visible_filenames.all?{|arg| arg.is_a?(String) }
      title = 'visible_filenames[i] is not a String'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, filename, msg)
      exit(26)
    end
  end

end
