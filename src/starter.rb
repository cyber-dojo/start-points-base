require 'json'

class Starter

  def initialize(type)
    @cache = {
      'names'     => read_names(type),
      'manifests' => read_manifests(type)
    }
  end

  def sha
    ENV['SHA']
  end

  def ready?
    true
  end

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

  def read_names(type)
    display_names = []
    pattern = "#{start_points_dir(type)}/**/manifest.json"
    Dir.glob(pattern).each do |manifest_filename|
      json = JSON.parse!(IO.read(manifest_filename))
      display_names << json['display_name']
    end
    display_names.sort
  end

  # - - - - - - - - - - - - - - - - - - - -

  def read_manifests(type)
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

  def cached_manifest(name)
    result = cache['manifests'][name]
    if result.nil?
      error('name', "#{name}:unknown")
    end
    result
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
