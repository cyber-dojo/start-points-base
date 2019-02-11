require_relative 'show_error'

module CheckVisibleFilenames

  include ShowError

  def check_visible_filenames(url, filename, json)
    visible_filenames = json['visible_filenames']
    unless visible_filenames.is_a?(Array)
      title = 'visible_filenames is not an Array'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, filename, msg)
      exit(25)
    end
    if visible_filenames.empty?
      title = 'visible_filenames is empty'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, filename, msg)
      exit(26)
    end
    unless visible_filenames.all?{|arg| arg.is_a?(String) }
      title = 'visible_filenames[i] is not a String'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, filename, msg)
      exit(27)
    end
    # TODO:check filenames dont have illegal characters (for a filename)
    # TODO:check all visible files exist and are world-readable
    # TODO:check no duplicate visible files
    # TODO:check cyber-dojo.sh is a visible_filename

  end

end
