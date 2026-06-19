require_relative 'show_error'

module CheckNameVersionPair

  include ShowError

  # Checks an optional [name,version] manifest entry, eg 'language' or
  # 'test_framework'. The value must be an Array of exactly 2 Strings,
  # eg ["Ruby","4.0.1"]. The version (2nd element) can be the empty
  # String (eg ["bash",""]) but the name (1st element) cannot.
  def check_name_version_pair(key, url, manifest_filename, json, error_code)
    return unless json.has_key?(key)
    value = json[key]
    ok = name_version_is_array(key, value, url, manifest_filename, error_code)
    ok &&= name_version_has_two_strings(key, value, url, manifest_filename, error_code)
    ok &&= name_version_elements_are_strings(key, value, url, manifest_filename, error_code)
    ok && name_version_name_is_not_empty(key, value, url, manifest_filename, error_code)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Fails unless value is an Array.
  def name_version_is_array(key, value, url, manifest_filename, error_code)
    if value.is_a?(Array)
      true
    else
      title = "#{key} is not an Array"
      msg = "#{quoted(key)}: #{value}"
      error(title, url, manifest_filename, msg, error_code)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Fails unless value has exactly 2 elements.
  def name_version_has_two_strings(key, value, url, manifest_filename, error_code)
    if value.size == 2
      true
    else
      title = "#{key} must be an Array of 2 Strings"
      msg = "#{quoted(key)}: #{value}"
      error(title, url, manifest_filename, msg, error_code)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Fails for each element of value that is not a String.
  def name_version_elements_are_strings(key, value, url, manifest_filename, error_code)
    result = true
    value.each_with_index do |element, index|
      unless element.is_a?(String)
        title = "#{key}[#{index}] is not a String"
        msg = "#{quoted(key)}: #{value}"
        result = error(title, url, manifest_filename, msg, error_code)
      end
    end
    result
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Fails when the name (1st element) is the empty String.
  def name_version_name_is_not_empty(key, value, url, manifest_filename, error_code)
    if value[0] == ''
      title = "#{key}[0]='' cannot be empty String"
      msg = "#{quoted(key)}: #{value}"
      error(title, url, manifest_filename, msg, error_code)
    else
      true
    end
  end

end
