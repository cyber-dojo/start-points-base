require_relative 'show_error'

module CheckFilenameExtension

  include ShowError

  def check_filename_extension(url, manifest_filename, json, error_code)
    ok = check_filename_extension_well_formed(url, manifest_filename, json, error_code)
    ok = ok && check_filename_extension_empty_string(url, manifest_filename, json, error_code)
    ok && check_filename_extension_dotless(url, manifest_filename, json, error_code)
    ok && check_filename_extension_only_dots(url, manifest_filename, json, error_code)
    ok && check_filename_extension_duplicates(url, manifest_filename, json, error_code)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def check_filename_extension_well_formed(url, manifest_filename, json, error_code)
    result = true
    filename_extension = get_filename_extension(json)
    unless filename_extension_is_well_formed?(filename_extension)
      title = 'filename_extension must be a String or Array of Strings'
      key = quoted('filename_extension')
      msg = "#{key}: #{filename_extension}"
      result = error(title, url, manifest_filename, msg, error_code)
    end
    result
  end

  def filename_extension_is_well_formed?(filename_extension)
    filename_extension.is_a?(Array) &&
      filename_extension != [] &&
        filename_extension.all?{|e| e.is_a?(String) }
  end

  def check_filename_extension_empty_string(url, manifest_filename, json, error_code)
    result = true
    filename_extension = get_filename_extension(json)
    filename_extension.each_with_index do |ext, index|
      if ext == ''
        title = "filename_extension[#{index}]='' cannot be empty String"
        key = quoted('filename_extension')
        msg = "#{key}: #{filename_extension}"
        result = error(title, url, manifest_filename, msg, error_code)
      end
    end
    result
  end

  def check_filename_extension_dotless(url, manifest_filename, json, error_code)
    filename_extension = get_filename_extension(json)
    filename_extension.each_with_index do |ext, index|
      unless ext[0] == '.'
        title = "filename_extension[#{index}]=#{quoted(ext)} must start with a dot"
        key = quoted('filename_extension')
        msg = "#{key}: #{filename_extension}"
        error(title, url, manifest_filename, msg, error_code)
      end
    end
  end

  def check_filename_extension_only_dots(url, manifest_filename, json, error_code)
    filename_extension = get_filename_extension(json)
    filename_extension.each_with_index do |ext, index|
      if ext == '.'
        title = "filename_extension[#{index}]=#{quoted(ext)} must be more than just a dot"
        key = quoted('filename_extension')
        msg = "#{key}: #{filename_extension}"
        error(title, url, manifest_filename, msg, error_code)
      end
    end
  end

  def check_filename_extension_duplicates(url, manifest_filename, json, error_code)
    filename_extension = get_filename_extension(json)
    filename_extension.each do |ext|
      dups = get_dup_indexes(filename_extension, ext)
      unless dups == []
        title = "filename_extension#{dups} are duplicates of #{quoted(ext)}"
        key = quoted('filename_extension')
        msg = "#{key}: #{filename_extension}"
        error(title, url, manifest_filename, msg, error_code)
        return # don't produce same error twice
      end
    end
  end

  def get_filename_extension(json)
    filename_extension = json['filename_extension']
    if filename_extension.is_a?(String)
      [ filename_extension ]
    else
      filename_extension
    end
  end

end
