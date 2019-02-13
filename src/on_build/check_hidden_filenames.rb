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
    unless hidden_filenames.all?{|s| s.is_a?(String) }
      title = 'hidden_filenames must be an Array of Strings'
      msg = "\"hidden_filenames\": #{hidden_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(39)
    end
    if hidden_filenames.any?{|s| s == '' }
      title = 'hidden_filenames must be an Array of Strings'
      msg = "\"hidden_filenames\": #{hidden_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(39)
    end
    hidden_filenames.each_with_index do |s,index|
      begin
        Regexp.new(s)
      rescue
        title = "hidden_filenames[#{index}] cannot create Regexp"
        msg = "\"hidden_filenames\": #{hidden_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(40)
      end
    end
    hidden_filenames.each do |filename|
      dup_indexes = get_dup_indexes(hidden_filenames, filename)
      unless dup_indexes == ''
        title = "hidden_filenames has duplicates #{dup_indexes}"
        msg = "\"hidden_filenames\": #{hidden_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(41)
      end
    end

  end

end
