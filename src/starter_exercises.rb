require 'json'

class StarterExercises

  def initialize
    @cache = {
      'display_names' => display_names,
      'manifests'     => manifests
    }
  end

  # - - - - - - - - - - - - - - - - -

  def ready?
    true
  end

  def sha
    ENV['SHA']
  end

  def start_points
    exercises_display_names = cache['display_names']
    Hash[
        exercises_display_names.map do |display_name|
          [ display_name, cached_exercise(display_name) ]
        end
      ]
  end

  def manifest(display_name)
    assert_string('display_name', display_name)
    cached_exercise(display_name)
  end

  private # = = = = = = = = = = = = =

  attr_reader :cache

  def display_names
    display_names = []
    pattern = "#{start_points_dir}/**/manifest.json"
    Dir.glob(pattern).each do |manifest_filename|
      json = JSON.parse!(IO.read(manifest_filename))
      display_names << json['display_name']
    end
    display_names.sort
  end

  def manifests
    manifests = {}
    pattern = "#{start_points_dir}/**/manifest.json"
    Dir.glob(pattern).each do |manifest_filename|
      manifest = JSON.parse!(IO.read(manifest_filename))
      display_name = manifest['display_name']
      visible_filenames = manifest['visible_filenames']
      dir = File.dirname(manifest_filename)
      manifest['visible_files'] =
        Hash[visible_filenames.map { |filename|
          [ filename,
            {
              'content' => IO.read("#{dir}/#{filename}")
            }
          ]
        }]
      manifest.delete('visible_filenames')
      manifest.delete('runner_choice')
      fe = manifest['filename_extension']
      if fe.is_a?(String)
        manifest['filename_extension'] = [ fe ]
      end
      manifests[display_name] = manifest
    end
    manifests
  end

  # - - - - - - - - - - - - - - - - - - - -

  def cached_exercise(display_name)
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

  # - - - - - - - - - - - - - - - - - - - -

  def start_points_dir
    '/app/repos/exercises'
  end

  # - - - - - - - - - - - - - - - - - - - -

  def assert_string(arg_name, arg)
    unless arg.is_a?(String)
      error(arg_name, '!string')
    end
  end

  # - - - - - - - - - - - - - - - - - - - -

  def error(name, diagnostic)
    raise ArgumentError.new("#{name}:#{diagnostic}")
  end

end
