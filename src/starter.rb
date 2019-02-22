require 'json'

class Starter

  def initialize
    @cache = {}

    @cache['languages'] = {
      'display_names' => display_names('languages'),
      'manifests'     => manifests('languages')
    }
    @cache['exercises'] = {
      'display_names' => display_names('exercises'),
      'manifests'     => manifests('exercises')
      #'CURRENT' => exercises,
    }
    @cache['custom'] = {
      'display_names' => display_names('custom'),
      'manifests'     => manifests('custom')
    }
  end

  # - - - - - - - - - - - - - - - - -

  def ready?
    true
  end

  def sha
    ENV['SHA']
  end

  # - - - - - - - - - - - - - - - - -
  # setting up a cyber-dojo: language,testFramwork + exercise
  # - - - - - - - - - - - - - - - - -

  def language_start_points
    languages_display_names = cache['languages']['display_names']
    exercises_display_names = cache['exercises']['display_names']
    {
      'languages' => languages_display_names,
      'exercises' => Hash[
        exercises_display_names.map do |display_name|
          [ display_name, cached_exercise(display_name) ]
        end
      ]
    }
  end

  def language_manifest(display_name, exercise_name)
    assert_string('display_name', display_name)
    assert_string('exercise_name', exercise_name)
    {
      'manifest' => cached_manifest('languages', display_name),
      'exercise' => cached_exercise(exercise_name)
    }
  end

  # - - - - - - - - - - - - - - - - -
  # setting up a cyber-dojo: custom
  # - - - - - - - - - - - - - - - - -

  def custom_start_points
    cache['custom']['display_names']
  end

  def custom_manifest(display_name)
    assert_string('display_name', display_name)
    cached_manifest('custom', display_name)
  end

  private # = = = = = = = = = = = = =

  attr_reader :cache

  def display_names(type)
    display_names = []
    pattern = "#{start_points_dir(type)}/**/manifest.json"
    Dir.glob(pattern).each do |manifest_filename|
      json = JSON.parse!(IO.read(manifest_filename))
      display_names << json['display_name']
    end
    display_names.sort
  end

  def manifests(type)
    manifests = {}
    pattern = "#{start_points_dir(type)}/**/manifest.json"
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

  def cached_manifest(type, display_name)
    result = cache[type]['manifests'][display_name]
    if result.nil?
      error('display_name', "#{display_name}:unknown")
    end
    result
  end

  def cached_exercise(display_name)
    manifest = cache['exercises']['manifests'][display_name]
    if manifest.nil?
      error('exercise_name', "#{display_name}:unknown")
    end
    manifest['visible_files']['instructions']
  end

  # - - - - - - - - - - - - - - - - - - - -

  def start_points_dir(type)
    "/app/repos/#{type}"
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
