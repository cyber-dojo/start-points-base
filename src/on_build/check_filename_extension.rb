require_relative 'show_error'

module CheckFilenameExtension

  include ShowError

  def check_filename_extension(url, manifest_filename, json)
    filename_extension = json['filename_extension']
    exit_unless_filename_extension_is_wrong_type(filename_extension, url, manifest_filename, json)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_filename_extension_is_wrong_type(filename_extension, url, manifest_filename, json)
    if filename_extension.is_a?(String)
      filename_extension = [ filename_extension ]
    end
    good = filename_extension.is_a?(Array)
    good = good && filename_extension != []
    good = good && filename_extension.all?{|e| e.is_a?(String) }
    unless good
      title = 'filename_extension must be a String or Array of Strings'
      msg = "\"filename_extension\": #{filename_extension}"
      show_error(title, url, manifest_filename, msg)
      exit(34)
    end
  end


end
