require_relative 'show_error'

module CheckHighlightFilenames

  include ShowError

  def check_highlight_filenames(url, manifest_filename, json, error_code)
    if json.has_key?('highlight_filenames')
      highlight_filenames = json['highlight_filenames']
      exit_unless_highlight_filenames_well_formed(highlight_filenames, url, manifest_filename, error_code)
      exit_unless_highlight_filenames_visible(highlight_filenames, url, manifest_filename, json, error_code)
      exit_if_highlight_filenames_duplicates(highlight_filenames, url, manifest_filename, error_code)
    end
  end

  def exit_unless_highlight_filenames_well_formed(highlight_filenames, url, manifest_filename, error_code)
    unless highlight_filenames_well_formed?(highlight_filenames)
      title = 'highlight_filenames must be an Array of Strings'
      key = quoted('highlight_filenames')
      msg = "#{key}: #{highlight_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def highlight_filenames_well_formed?(highlight_filenames)
    highlight_filenames.is_a?(Array) &&
      highlight_filenames != [] &&
        highlight_filenames.all?{|s| s.is_a?(String) } &&
          highlight_filenames.all?{|s| s != '' }
  end

  def exit_unless_highlight_filenames_visible(highlight_filenames, url, manifest_filename, json, error_code)
    visible_filenames = json['visible_filenames']
    highlight_filenames.each_with_index do |filename,index|
      unless visible_filenames.include?(filename)
        title = "highlight_filenames[#{index}] not in visible_filenames"
        key = quoted('highlight_filenames')
        msg = "#{key}: #{highlight_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_if_highlight_filenames_duplicates(highlight_filenames, url, manifest_filename, error_code)
    highlight_filenames.each do |filename|
      dup_indexes = get_dup_indexes(highlight_filenames, filename)
      unless dup_indexes == ''
        title = "highlight_filenames has duplicates #{dup_indexes}"
        key = quoted('highlight_filenames')
        msg = "#{key}: #{highlight_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

end
