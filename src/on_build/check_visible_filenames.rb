require_relative 'show_error'

module CheckVisibleFilenames

  include ShowError

  def check_visible_filenames(url, manifest_filename, json)
    visible_filenames = json['visible_filenames']
    exit_unless_visible_filenames_is_array(visible_filenames, url, manifest_filename)
    exit_if_visible_filenames_is_empty(visible_filenames, url, manifest_filename)
    visible_filenames.each_with_index do |filename,index|
      exit_unless_visible_filename_is_a_String(visible_filenames, filename, index, url, manifest_filename)
      exit_if_visible_filename_is_empty(visible_filenames, filename, index, url, manifest_filename)
      exit_unless_visible_filename_is_portable(visible_filenames, filename, index, url, manifest_filename)
    end
    exit_if_visible_filename_duplicate(visible_filenames, url, manifest_filename)
    # TODO:32.check all visible files exist and are world-readable
    # TODO:33.check cyber-dojo.sh is a visible_filename

  end

  # - - - - - - - - - - - - - - - - - - - -

  def exit_unless_visible_filenames_is_array(visible_filenames, url, manifest_filename)
    unless visible_filenames.is_a?(Array)
      title = 'visible_filenames is not an Array'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(25)
    end
  end

  def exit_if_visible_filenames_is_empty(visible_filenames, url, manifest_filename)
    if visible_filenames.empty?
      title = 'visible_filenames is empty'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(26)
    end
  end

  def exit_unless_visible_filename_is_a_String(visible_filenames, filename, index, url, manifest_filename)
    unless filename.is_a?(String)
      title = "visible_filenames[#{index}] is not a String"
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(27)
    end
  end

  def exit_if_visible_filename_is_empty(visible_filenames, filename, index, url, manifest_filename)
    if filename.empty?
      title = "visible_filenames[#{index}] is empty"
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(28)
    end
  end

  def exit_unless_visible_filename_is_portable(visible_filenames, filename, index, url, manifest_filename)
    filename.each_char do |ch|
      unless portable?(ch)
        title = "visible_filenames[#{index}] has non-portable character '#{ch}'"
        msg = "\"visible_filenames\": #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(29)
      end
    end
    if filename[0] == '-'
      title = "visible_filenames[#{index}] has non-portable leading character '-'"
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(30)
    end
  end

  def exit_if_visible_filename_duplicate(visible_filenames, url, manifest_filename)
    visible_filenames.each do |filename|
      dup_indexes = get_dup_indexes(visible_filenames, filename)
      unless dup_indexes == ''
        title = "visible_filenames has duplicates #{dup_indexes}"
        msg = "\"visible_filenames\": #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(31)
      end
    end
  end

  def get_dup_indexes(all, value)
    (0...all.size).each do |i|
      dups = all.each_index.select { |index| all[i] == all[index] }
      if dups.size != 1
        return dups.map{|i| "[#{i}]"}.join
      end
    end
    return ''
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
