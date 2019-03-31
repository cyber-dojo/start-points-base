require_relative 'api'
require_relative 'http_helper'
require_relative 'unknown_method'

class ExercisesService

  include Api
  include UnknownMethod

  private

  def http
    HttpHelper.new(self, 'exercises', 4525)
  end

end
