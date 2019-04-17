require_relative 'show_error'

module CheckFilenameExtension

  include ShowError

  def check_filename_extension(url, manifest_filename, json, error_code)
    filename_extension = json['filename_extension']
    if filename_extension.is_a?(String)
      filename_extension = [ filename_extension ]
    end
    exit_unless_filename_extension_is_well_formed(filename_extension, url, manifest_filename, error_code)
    exit_if_filename_extension_is_empty_string(filename_extension, url, manifest_filename, error_code)
    exit_if_filename_extension_dotless(filename_extension, url, manifest_filename, error_code)
    exit_if_filename_extension_only_dots(filename_extension, url, manifest_filename, error_code)
    exit_if_filename_extension_duplicates(filename_extension, url, manifest_filename, error_code)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_filename_extension_is_well_formed(filename_extension, url, manifest_filename, error_code)
    unless filename_extension_is_well_formed?(filename_extension)
      title = 'filename_extension must be a String or Array of Strings'
      key = quoted('filename_extension')
      msg = "#{key}: #{filename_extension}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def filename_extension_is_well_formed?(filename_extension)
    filename_extension.is_a?(Array) &&
      filename_extension != [] &&
        filename_extension.all?{|e| e.is_a?(String) }
  end

  def exit_if_filename_extension_is_empty_string(filename_extension, url, manifest_filename, error_code)
    filename_extension.each_with_index do |ext, index|
      if ext == ''
        title = "filename_extension[#{index}] must be non-empty String"
        key = quoted('filename_extension')
        msg = "#{key}: #{filename_extension}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_if_filename_extension_dotless(filename_extension, url, manifest_filename, error_code)
    filename_extension.each_with_index do |ext, index|
      unless ext[0] == '.'
        title = "filename_extension[#{index}] must start with a dot"
        key = quoted('filename_extension')
        msg = "#{key}: #{filename_extension}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_if_filename_extension_only_dots(filename_extension, url, manifest_filename, error_code)
    filename_extension.each_with_index do |ext, index|
      if ext == '.'
        title = "filename_extension[#{index}] must be more than just a dot"
        key = quoted('filename_extension')
        msg = "#{key}: #{filename_extension}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_if_filename_extension_duplicates(filename_extension, url, manifest_filename, error_code)
    filename_extension.each do |ext|
      dup_indexes = get_dup_indexes(filename_extension, ext)
      unless dup_indexes == ''
        title = "filename_extension has duplicates #{dup_indexes}"
        key = quoted('filename_extension')
        msg = "#{key}: #{filename_extension}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

end
