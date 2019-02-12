require_relative 'show_error'

module CheckFilenameExtension

  include ShowError

  def check_filename_extension(url, manifest_filename, json)
    filename_extension = json['filename_extension']
    exit_unless_filename_extension_is_string_or_array_of_strings(filename_extension, url, manifest_filename, json)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_filename_extension_is_string_or_array_of_strings(filename_extension, url, manifest_filename, json)
    unless filename_extension.is_a?(String)
      title = 'filename_extension must be a String or Array of Strings'
      msg = "\"filename_extension\": #{filename_extension}"
      show_error(title, url, manifest_filename, msg)
      exit(34)
    end
  end


end
