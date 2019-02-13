require_relative 'show_error'

module CheckFilenameExtension

  include ShowError

  def check_filename_extension(url, manifest_filename, json)
    filename_extension = json['filename_extension']
    if filename_extension.is_a?(String)
      filename_extension = [ filename_extension ]
    end
    exit_unless_filename_extension_is_well_formed(filename_extension, url, manifest_filename, json)
    exit_if_filename_extension_is_empty_string(filename_extension, url, manifest_filename, json)
    exit_if_filename_extension_dotless(filename_extension, url, manifest_filename, json)
    exit_if_filename_extension_only_dots(filename_extension, url, manifest_filename, json)
    exit_if_filename_extension_duplicates(filename_extension, url, manifest_filename, json)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_filename_extension_is_well_formed(filename_extension, url, manifest_filename, json)
    unless filename_extension_is_well_formed?(filename_extension)
      title = 'filename_extension must be a String or Array of Strings'
      msg = "\"filename_extension\": #{filename_extension}"
      show_error(title, url, manifest_filename, msg)
      exit(34)
    end
  end

  def filename_extension_is_well_formed?(filename_extension)
    filename_extension.is_a?(Array) &&
      filename_extension != [] &&
        filename_extension.all?{|e| e.is_a?(String) }
  end

  def exit_if_filename_extension_is_empty_string(filename_extension, url, manifest_filename, json)
    filename_extension.each_with_index do |ext, index|
      if ext == ''
        title = "filename_extension[#{index}] must be non-empty String"
        msg = "\"filename_extension\": #{filename_extension}"
        show_error(title, url, manifest_filename, msg)
        exit(35)
      end
    end
  end

  def exit_if_filename_extension_dotless(filename_extension, url, manifest_filename, json)
    filename_extension.each_with_index do |ext, index|
      unless ext[0] == '.'
        title = "filename_extension[#{index}] must start with a dot"
        msg = "\"filename_extension\": #{filename_extension}"
        show_error(title, url, manifest_filename, msg)
        exit(36)
      end
    end
  end

  def exit_if_filename_extension_only_dots(filename_extension, url, manifest_filename, json)
    filename_extension.each_with_index do |ext, index|
      if ext == '.'
        title = "filename_extension[#{index}] must be more than just a dot"
        msg = "\"filename_extension\": #{filename_extension}"
        show_error(title, url, manifest_filename, msg)
        exit(37)
      end
    end
  end

  def exit_if_filename_extension_duplicates(filename_extension, url, manifest_filename, json)
    filename_extension.each do |ext|
      dup_indexes = get_dup_indexes(filename_extension, ext)
      unless dup_indexes == ''
        title = "filename_extension has duplicates #{dup_indexes}"
        msg = "\"filename_extension\": #{filename_extension}"
        show_error(title, url, manifest_filename, msg)
        exit(38)
      end
    end
  end

end
