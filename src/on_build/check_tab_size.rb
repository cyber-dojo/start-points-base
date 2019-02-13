require_relative 'show_error'

module CheckTabSize

  include ShowError

  def check_tab_size(url, manifest_filename, json)
    if json.has_key?('tab_size')
      tab_size = json['tab_size']
      exit_unless_tab_size_is_integer(tab_size, url, manifest_filename, json)
      exit_unless_tab_size_in_range(tab_size, url, manifest_filename, json)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_tab_size_is_integer(tab_size, url, manifest_filename, json)
    unless tab_size.is_a?(Integer)
      title = 'tab_size must be an Integer'
      if tab_size.is_a?(String)
        msg = "\"tab_size\": \"#{tab_size}\""
      else
        msg = "\"tab_size\": #{tab_size}"
      end
      show_error(title, url, manifest_filename, msg)
      exit(42)
    end
  end

  def exit_unless_tab_size_in_range(tab_size, url, manifest_filename, json)
    unless (1..8).include?(tab_size)
      title = 'tab_size must be an Integer (1..8)'
      msg = "\"tab_size\": #{tab_size}"
      show_error(title, url, manifest_filename, msg)
      exit(43)
    end    
  end

end
