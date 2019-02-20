require_relative 'show_error'

module CheckNoUnknownKeysExist

  include ShowError

  def check_no_unknown_keys_exist(known_keys, url, filename, json, error_code)
    json.keys.each do |key|
      unless known_keys.include?(key)
        title = "unknown key \"#{key}\""
        show_error(title, url, filename)
        exit(error_code)
      end
    end
  end

end
