require_relative 'show_error'

module CheckRunnerChoice

  include ShowError

  def check_runner_choice(url, manifest_filename, json)
    if json.has_key?('runner_choice')
      runner_choice = json['runner_choice']
      title = 'runner_choice is no longer used. Please remove'
      msg = "\"runner_choice\": \"#{runner_choice}\""
      show_error(title, url, manifest_filename, msg)
      exit(49)
    end
  end

end
