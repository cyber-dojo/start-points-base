require 'json'

class Starter

  def initialize
    @cache = {}

    @cache['languages'] = {
      'display_names' => display_names('languages'),
      'manifests'     => manifests('languages'),
      'exercises'     => exercises
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
    {
      'languages' => cache['languages']['display_names'],
      'exercises' => cache['languages']['exercises']
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
    markers = "#{start_points_dir}/**/#{type}.marker"
    Dir.glob(markers).each do |marker_filename|
      pattern = "#{File.dirname(marker_filename)}/**/manifest.json"
      Dir.glob(pattern).each do |manifest_filename|
        json = JSON.parse!(IO.read(manifest_filename))
        display_names << json['display_name']
      end
    end
    display_names.sort
  end

  def manifests(type)
    manifests = {}
    markers = "#{start_points_dir}/**/#{type}.marker"
    Dir.glob(markers).each do |marker_filename|
      pattern = "#{File.dirname(marker_filename)}/**/manifest.json"
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
    end
    manifests
  end

  # - - - - - - - - - - - - - - - - - - - -

  def exercises
    result = {}
    markers = "#{start_points_dir}/**/exercises.marker"
    Dir.glob(markers).each do |marker_filename|
      pattern = "#{File.dirname(marker_filename)}/**/instructions"
      Dir.glob(pattern).each do |filename|
        name = filename.split('/')[-2] # eg Bowling_Game
        result[name] = {
          'content' => IO.read(filename)
        }
      end
    end
    result
  end

  # - - - - - - - - - - - - - - - - - - - -

  def cached_manifest(type, display_name)
    result = cache[type]['manifests'][display_name]
    if result.nil?
      error('display_name', "#{display_name}:unknown")
    end
    result
  end

  def cached_exercise(exercise_name)
    result = cache['languages']['exercises'][exercise_name]
    if result.nil?
      error('exercise_name', "#{exercise_name}:unknown")
    end
    result
  end

  # - - - - - - - - - - - - - - - - - - - -

  def start_points_dir
    '/app/repos'
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
