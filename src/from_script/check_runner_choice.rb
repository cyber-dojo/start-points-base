require_relative 'show_error'

module CheckRunnerChoice

  include ShowError

  def check_runner_choice(url, manifest_filename, json, error_code)
    if json.has_key?('runner_choice')
      runner_choice = json['runner_choice']
      title = 'runner_choice is no longer used. Please remove'
      key = quoted('runner_choice')
      msg = "#{key}: \"#{runner_choice}\""
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

end
