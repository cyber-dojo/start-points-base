require_relative 'show_error'

module CheckHiddenFilenames

  include ShowError

  def check_hidden_filenames(url, manifest_filename, json, error_code)
    if json.has_key?('hidden_filenames')
      hidden_filenames = json['hidden_filenames']
      exit_unless_hidden_filenames_well_formed(hidden_filenames, url, manifest_filename, error_code)
      exit_if_hidden_filenames_bad_regexp(hidden_filenames, url, manifest_filename, error_code)
      exit_if_hidden_filenames_has_duplicates(hidden_filenames, url, manifest_filename, error_code)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_hidden_filenames_well_formed(hidden_filenames, url, manifest_filename, error_code)
    unless hidden_filenames_well_formed?(hidden_filenames)
      title = 'hidden_filenames must be an Array of Strings'
      key = quoted('hidden_filenames')
      msg = "#{key}: #{hidden_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def hidden_filenames_well_formed?(hidden_filenames)
    hidden_filenames.is_a?(Array) &&
      hidden_filenames != [] &&
        hidden_filenames.all?{|s| s.is_a?(String) } &&
          hidden_filenames.all?{|s| s != '' }
  end

  def exit_if_hidden_filenames_bad_regexp(hidden_filenames, url, manifest_filename, error_code)
    hidden_filenames.each_with_index do |s,index|
      begin
        Regexp.new(s)
      rescue
        title = "hidden_filenames[#{index}]=#{quoted(s)} cannot create Regexp"
        key = quoted('hidden_filenames')
        msg = "#{key}: #{hidden_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_if_hidden_filenames_has_duplicates(hidden_filenames, url, manifest_filename, error_code)
    hidden_filenames.each do |filename|
      dups = get_dup_indexes(hidden_filenames, filename)
      unless dups == []
        title = "hidden_filenames#{dups} are duplicates of #{quoted(filename)}"
        key = quoted('hidden_filenames')
        msg = "#{key}: #{hidden_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

end
