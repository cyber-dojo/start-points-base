require_relative 'show_error'

module CheckProgressRegexs

  include ShowError

  def check_progress_regexs(url, manifest_filename, json)
    if json.has_key?('progress_regexs')
      progress_regexs = json['progress_regexs']
      exit_unless_progress_regexs_well_formed(progress_regexs, url, manifest_filename, json)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_progress_regexs_well_formed(progress_regexs, url, manifest_filename, json)
    unless progress_regexs_well_formed?(progress_regexs)
      title = 'progress_regexs must be an Array of 2 Strings'
      if progress_regexs.is_a?(String)
        msg = "\"progress_regexs\": \"#{progress_regexs}\""
      else
        msg = "\"progress_regexs\": #{progress_regexs}"
      end
      show_error(title, url, manifest_filename, msg)
      exit(47)
    end
  end

  def progress_regexs_well_formed?(arg)
    arg.is_a?(Array) &&
      arg.size == 2 &&
        arg.all?{|s| s.is_a?(String)} &&
          arg.all?{|s| s != ''}
  end

end
