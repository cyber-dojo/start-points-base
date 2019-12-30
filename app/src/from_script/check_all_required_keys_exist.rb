require_relative 'show_error'

module CheckAllRequiredKeysExist

  include ShowError

  def check_all_required_keys_exist(required_keys, url, filename, json, error_code)
    required_keys.each do |key|
      unless json.keys.include?(key)
        title = "missing required key \"#{key}\""
        show_error(title, url, filename)
        @error_codes << error_code
      end
    end
  end

end
