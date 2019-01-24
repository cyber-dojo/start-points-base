require_relative 'http_helper'

class StarterService

  def sha
    http.get
  end

  def language_start_points
    http.get
  end

  def language_manifest(display_name, exercise_name)
    http.get(display_name, exercise_name)
  end

  def custom_start_points
    http.get
  end

  def custom_manifest(display_name)
    http.get(display_name)
  end

  private

  def http
    HttpHelper.new(self, 'starter', 4527)
  end

end
