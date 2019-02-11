require_relative 'show_error'

module CheckVisibleFilenames

  include ShowError

  def check_visible_filenames(url, manifest_filename, json)
    visible_filenames = json['visible_filenames']
    unless visible_filenames.is_a?(Array)
      title = 'visible_filenames is not an Array'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(25)
    end
    if visible_filenames.empty?
      title = 'visible_filenames is empty'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(26)
    end
    visible_filenames.each_with_index do |filename,index|
      unless filename.is_a?(String)
        title = "visible_filenames[#{index}] is not a String"
        msg = "\"visible_filenames\": #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(27)
      end
      if filename.empty?
        title = "visible_filenames[#{index}] is empty"
        msg = "\"visible_filenames\": #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(28)
      end
      filename.each_char do |ch|
        unless portable?(ch)
          title = "visible_filenames[#{index}] has non-portable character '#{ch}'"
          msg = "\"visible_filenames\": #{visible_filenames}"
          show_error(title, url, manifest_filename, msg)
          exit(29)
        end
      end
    end
    # TODO:30.check no duplicate visible files
    # TODO:31.check all visible files exist and are world-readable
    # TODO:32.check cyber-dojo.sh is a visible_filename

  end

  def portable?(ch)
    # http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_278
    upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    lower = 'abcdefghijklmnopqrstuvwxyz'
    digits = '0123456789'
    extra = '._-'
    (upper+lower+digits+extra).include?(ch)
  end

end
