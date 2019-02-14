require_relative 'show_error'

module CheckHighlightFilenames

  include ShowError

  def check_highlight_filenames(url, manifest_filename, json)
    if json.has_key?('highlight_filenames')
      highlight_filenames = json['highlight_filenames']
      exit_unless_highlight_filenames_well_formed(highlight_filenames, url, manifest_filename, json)
    end
  end

  def exit_unless_highlight_filenames_well_formed(highlight_filenames, url, manifest_filename, json)
    unless highlight_filenames_well_formed?(highlight_filenames)
      title = 'highlight_filenames must be an Array of Strings'
      msg = "\"highlight_filenames\": #{highlight_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(46)
    end
  end

  def highlight_filenames_well_formed?(highlight_filenames)
    highlight_filenames.is_a?(Array) &&
      highlight_filenames != [] &&
        highlight_filenames.all?{|s| s.is_a?(String) } &&
          highlight_filenames.all?{|s| s != '' }
  end

end
