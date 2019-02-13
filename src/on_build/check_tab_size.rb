require_relative 'show_error'

module CheckTabSize

  include ShowError

  def check_tab_size(url, manifest_filename, json)
    if json.has_key?('tab_size')
      tab_size = json['tab_size']
      #...
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - -


end
