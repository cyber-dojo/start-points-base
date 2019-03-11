require 'json'
require_relative 'starter'

class StarterLanguages

  def initialize
    @cache = {
      'display_names' => display_names('languages'),
      'manifests'     => manifests('languages')
    }
  end

  def start_points
    cache['display_names']
  end

  def manifest(display_name)
    assert_string('display_name', display_name)
    cached_manifest(display_name)
  end

  private

  attr_reader :cache
  include Starter

end
