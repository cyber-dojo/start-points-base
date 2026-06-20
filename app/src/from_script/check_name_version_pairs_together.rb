require_relative 'show_error'

module CheckNameVersionPairsTogether

  include ShowError

  # The optional 'language' and 'test_framework' manifest entries are
  # coupled: a manifest must declare both or neither. Declaring only one
  # leaves the structured data half-populated, so it is rejected.
  def check_name_version_pairs_together(url, manifest_filename, json, error_code)
    has_language = json.has_key?('language')
    has_test_framework = json.has_key?('test_framework')
    if has_language == has_test_framework
      true
    else
      present = has_language ? 'language' : 'test_framework'
      missing = has_language ? 'test_framework' : 'language'
      title = 'language and test_framework must both be present or both absent'
      msg = "has #{quoted(present)} but not #{quoted(missing)}"
      error(title, url, manifest_filename, msg, error_code)
    end
  end

end
