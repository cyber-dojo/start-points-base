require_relative 'api'
require_relative 'http_helper'
require_relative 'unknown_method'

class LanguagesService

  include Api
  include UnknownMethod

  private

  def http
    HttpHelper.new(self, 'languages', 4525)
  end

end
