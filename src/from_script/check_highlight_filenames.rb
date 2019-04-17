require_relative 'show_error'

module CheckHighlightFilenames

  include ShowError

  def check_highlight_filenames(url, manifest_filename, json, error_code)
    if json.has_key?('highlight_filenames')
      ok = highlight_filenames_well_formed(url, manifest_filename, json, error_code)
      ok && highlight_filenames_visible(url, manifest_filename, json, error_code)
      ok && highlight_filenames_duplicates(url, manifest_filename, json, error_code)
    end
  end

  def highlight_filenames_well_formed(url, manifest_filename, json, error_code)
    result = true
    highlight_filenames = json['highlight_filenames']
    unless highlight_filenames_well_formed?(highlight_filenames)
      title = 'highlight_filenames must be an Array of Strings'
      key = quoted('highlight_filenames')
      msg = "#{key}: #{highlight_filenames}"
      result = error(title, url, manifest_filename, msg, error_code)
    end
    result
  end

  def highlight_filenames_well_formed?(highlight_filenames)
    highlight_filenames.is_a?(Array) &&
      highlight_filenames != [] &&
        highlight_filenames.all?{|s| s.is_a?(String) } &&
          highlight_filenames.all?{|s| s != '' }
  end

  def highlight_filenames_visible(url, manifest_filename, json, error_code)
    highlight_filenames = json['highlight_filenames']
    visible_filenames = json['visible_filenames']
    highlight_filenames.each_with_index do |filename,index|
      unless visible_filenames.include?(filename)
        title = "highlight_filenames[#{index}]=#{quoted(filename)} not in visible_filenames"
        key = quoted('highlight_filenames')
        msg = "#{key}: #{highlight_filenames}"
        error(title, url, manifest_filename, msg, error_code)
      end
    end
  end

  def highlight_filenames_duplicates(url, manifest_filename, json, error_code)
    highlight_filenames = json['highlight_filenames']
    highlight_filenames.each do |filename|
      dups = get_dup_indexes(highlight_filenames, filename)
      unless dups == []
        title = "highlight_filenames#{dups} are duplicates of #{quoted(filename)}"
        key = quoted('highlight_filenames')
        msg = "#{key}: #{highlight_filenames}"
        error(title, url, manifest_filename, msg, error_code)
        return # don't produce same error twice
      end
    end
  end

end
