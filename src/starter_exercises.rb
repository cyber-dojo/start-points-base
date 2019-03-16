require 'json'
require_relative 'ready'
require_relative 'sha'
require_relative 'starter'

class StarterExercises

  def initialize
    @cache = {
      'display_names' => read_names('exercises'),
      'manifests'     => read_manifests('exercises')
    }
  end

  include Ready
  include Sha

  def start_points
    exercises_display_names = cache['display_names']
    Hash[
        exercises_display_names.map do |display_name|
          [ display_name, readme(display_name) ]
        end
      ]
  end

  def manifest(display_name)
    assert_string('display_name', display_name)
    cached_manifest(display_name)
  end

  private

  attr_reader :cache
  include Starter

  def readme(display_name)
    manifest = cache['manifests'][display_name]
    if manifest.nil?
      error('exercise_name', "#{display_name}:unknown")
    end
    visible_files = manifest['visible_files']
    if visible_files.has_key?('instructions')
      return visible_files['instructions']
    end
    if visible_files.has_key?('readme.txt')
      return visible_files['readme.txt']
    end
    # else largest file
    visible_files.max{ |lhs,rhs| lhs[1].size <=> rhs[1].size }[1]
  end

end
