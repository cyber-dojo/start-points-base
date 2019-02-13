require_relative 'show_error'

module CheckHiddenFilenames

  include ShowError

  def check_hidden_filenames(url, manifest_filename, json)
    unless json.has_key?('hidden_filenames')
      return
    end
    hidden_filenames = json['hidden_filenames']
    unless hidden_filenames.is_a?(Array)
      title = 'hidden_filenames must be an Array of Strings'
      msg = "\"hidden_filenames\": #{hidden_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(39)
    end

  end

end
