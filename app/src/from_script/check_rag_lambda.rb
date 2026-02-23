require_relative 'show_error'

module CheckRagLambda

  include ShowError

  def check_rag_lambda(url, manifest_filename, json, error_code)
    filename = json['rag_lambda']
    return if filename.nil?

    ok = check_rag_lambda_is_a_String(filename, url, manifest_filename, error_code)
    ok &&= check_rag_lambda_is_non_empty_String(filename, url, manifest_filename, error_code)
    ok &&= check_rag_lambda_filename_exists(filename, url, manifest_filename, error_code)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def check_rag_lambda_is_a_String(filename, url, manifest_filename, error_code)
    unless filename.is_a?(String)
      title = "rag_lambda is not a String"
      key = quoted('rag_lambda')
      msg = "#{key}: #{filename}"
      error(title, url, manifest_filename, msg, error_code)
      false
    else
      true
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def check_rag_lambda_is_non_empty_String(filename, url, manifest_filename, error_code)
    if filename == ""
      title = "rag_lambda is an empty String"
      key = quoted('rag_lambda')
      value = quoted(filename)
      msg = "#{key}: #{value}"
      error(title, url, manifest_filename, msg, error_code)
      false
    else
      true
    end
  end

  def check_rag_lambda_filename_exists(filename, url, manifest_filename, error_code)
    result = true
    dir_name = File.dirname(manifest_filename)
    unless File.exist?(dir_name + '/' + filename)
      title = "rag_lambda file does not exist"
      key = quoted('rag_lambda')
      value = quoted(filename)
      msg = "#{key}: #{value}"
      result = error(title, url, manifest_filename, msg, error_code)
    end
    result
  end

end
