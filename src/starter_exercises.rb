require 'json'
require_relative 'ready'
require_relative 'sha'
require_relative 'starter'

class StarterExercises

  def initialize
    @cache = {
      'names'     => read_names('exercises'),
      'manifests' => read_manifests('exercises')
    }
  end

  include Ready
  include Sha

  def names
    cache['names']
  end

  def manifests
    cache['manifests']
  end

  def manifest(name)
    assert_string('name', name)
    cached_manifest(name)
  end

  private

  attr_reader :cache
  include Starter

end
