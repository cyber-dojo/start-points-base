require_relative 'api'
require_relative 'http_helper'
require_relative 'unknown_method'

class CustomService

  include Api
  include UnknownMethod

  private

  def http
    HttpHelper.new(self, 'custom', 4526)
  end

end
