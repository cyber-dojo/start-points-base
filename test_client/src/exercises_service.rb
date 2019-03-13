require_relative 'api'
require_relative 'http_helper'

class ExercisesService

  include Api
  
  def wibble # unknown
    http.get
  end

  private

  def http
    HttpHelper.new(self, 'exercises', 4526)
  end

end
