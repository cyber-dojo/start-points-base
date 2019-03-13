require_relative 'api'
require_relative 'http_helper'

class LanguagesService

  include Api

  def wibble # unknown
    http.get
  end

  private

  def http
    HttpHelper.new(self, 'languages', 4525)
  end

end
