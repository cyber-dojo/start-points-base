require_relative 'show_error'

module CheckProgressRegexs

  include ShowError

  def check_progress_regexs(url, manifest_filename, json, error_code)
    if json.has_key?('progress_regexs')
      progress_regexs = json['progress_regexs']
      exit_unless_progress_regexs_well_formed(progress_regexs, url, manifest_filename, error_code)
      exit_if_progress_regexs_bad_regexp(progress_regexs, url, manifest_filename, error_code)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_progress_regexs_well_formed(progress_regexs, url, manifest_filename,error_code)
    unless progress_regexs_well_formed?(progress_regexs)
      title = 'progress_regexs must be an Array of 2 Strings'
      key = quoted('progress_regexs')
      if progress_regexs.is_a?(String)
        msg = "#{key}: \"#{progress_regexs}\""
      else
        msg = "#{key}: #{progress_regexs}"
      end
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def progress_regexs_well_formed?(arg)
    arg.is_a?(Array) &&
      arg.size == 2 &&
        arg.all?{|s| s.is_a?(String)} &&
          arg.all?{|s| s != ''}
  end

  def exit_if_progress_regexs_bad_regexp(progress_regexs, url, manifest_filename, error_code)
    progress_regexs.each_with_index do |s,index|
      begin
        Regexp.new(s)
      rescue
        title = "progress_regexs[#{index}] cannot create Regexp"
        key = quoted('progress_regexs')
        msg = "#{key}: #{progress_regexs}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

end
