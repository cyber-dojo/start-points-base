require_relative 'api'
require_relative 'http_helper'

class CustomService

  include Api

  def wibble # unknown
    http.get
  end

  private

  def http
    HttpHelper.new(self, 'custom', 4527)
  end

end
