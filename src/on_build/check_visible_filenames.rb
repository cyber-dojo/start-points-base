require_relative 'show_error'

module CheckVisibleFilenames

  include ShowError

  def check_visible_filenames(url, manifest_filename, json, error_code)
    visible_filenames = json['visible_filenames']
    exit_unless_visible_filenames_is_array(visible_filenames, url, manifest_filename, error_code)
    exit_if_visible_filenames_is_empty(visible_filenames, url, manifest_filename, error_code)
    visible_filenames.each_with_index do |filename,index|
      exit_unless_visible_filename_is_a_String(visible_filenames, filename, index, url, manifest_filename, error_code)
      exit_if_visible_filename_is_empty(visible_filenames, filename, index, url, manifest_filename, error_code)
      exit_unless_visible_filename_is_portable(visible_filenames, filename, index, url, manifest_filename, error_code)
    end
    exit_if_visible_filename_duplicate(visible_filenames, url, manifest_filename, error_code)
    exit_unless_all_visible_filenames_exist(visible_filenames, url, manifest_filename, error_code)
    exit_if_visible_file_too_large(visible_filenames, url, manifest_filename, error_code)
    exit_unless_visible_filename_includes_cyber_dojo_sh(visible_filenames, url, manifest_filename, error_code)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_visible_filenames_is_array(visible_filenames, url, manifest_filename, error_code)
    unless visible_filenames.is_a?(Array)
      title = 'visible_filenames is not an Array'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_if_visible_filenames_is_empty(visible_filenames, url, manifest_filename, error_code)
    if visible_filenames.empty?
      title = 'visible_filenames is empty'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_unless_visible_filename_is_a_String(visible_filenames, filename, index, url, manifest_filename, error_code)
    unless filename.is_a?(String)
      title = "visible_filenames[#{index}] is not a String"
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_if_visible_filename_is_empty(visible_filenames, filename, index, url, manifest_filename, error_code)
    if filename.empty?
      title = "visible_filenames[#{index}] is empty"
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_unless_visible_filename_is_portable(visible_filenames, filename, index, url, manifest_filename, error_code)
    filename.each_char do |ch|
      unless portable?(ch)
        title = "visible_filenames[#{index}] has non-portable character '#{ch}'"
        msg = "\"visible_filenames\": #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
    if filename[0] == '-'
      title = "visible_filenames[#{index}] has non-portable leading character '-'"
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_if_visible_filename_duplicate(visible_filenames, url, manifest_filename, error_code)
    visible_filenames.each do |filename|
      dup_indexes = get_dup_indexes(visible_filenames, filename)
      unless dup_indexes == ''
        title = "visible_filenames has duplicates #{dup_indexes}"
        msg = "\"visible_filenames\": #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_unless_all_visible_filenames_exist(visible_filenames, url, manifest_filename, error_code)
    dir_name = File.dirname(manifest_filename)
    visible_filenames.each_with_index do |filename,index|
      unless File.exists?(dir_name + '/' + filename)
        title = "visible_filenames[#{index}] does not exist"
        msg = "\"visible_filenames\": #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_if_visible_file_too_large(visible_filenames, url, manifest_filename, error_code)
    dir_name = File.dirname(manifest_filename)
    visible_filenames.each_with_index do |filename,index|
      if File.size("#{dir_name}/#{filename}") > 25*1024
        title = "visible_filenames[#{index}] is too large (>25K)"
        msg = "\"visible_filenames\": #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_unless_visible_filename_includes_cyber_dojo_sh(visible_filenames, url, manifest_filename, error_code)
    return if @type == 'exercises'
    unless visible_filenames.include?('cyber-dojo.sh')
      title = 'visible_filenames does not include "cyber-dojo.sh"'
      msg = "\"visible_filenames\": #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

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
    # I also allow forward slash since some filenames include dirs.
    upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    lower = 'abcdefghijklmnopqrstuvwxyz'
    digits = '0123456789'
    extra = '/._-'
    (upper+lower+digits+extra).include?(ch)
  end

end
