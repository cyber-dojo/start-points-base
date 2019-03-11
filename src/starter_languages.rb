require 'json'

class StarterLanguages

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
    cache['display_names']
  end

  def manifest(display_name)
    assert_string('display_name', display_name)
    cached_manifest(display_name)
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

  def cached_manifest(display_name)
    result = cache['manifests'][display_name]
    if result.nil?
      error('display_name', "#{display_name}:unknown")
    end
    result
  end

  # - - - - - - - - - - - - - - - - - - - -

  def start_points_dir
    '/app/repos/languages'
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
