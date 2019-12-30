require 'json'

class Starter

  def initialize
    @names = read_names
    @manifests = read_manifests
  end

  def sha
    ENV['SHA'] || ENV['BASE_SHA']
  end

  def alive?
    true
  end

  def ready?
    true
  end

  attr_reader :names, :manifests

  def manifest(name)
    unless name.is_a?(String)
      error('name', '!string')
    end
    result = manifests[name]
    if result.nil?
      error('name', "#{name}:unknown")
    end
    result
  end

  def image_names
    manifests.map{ |_,manifest| manifest['image_name'] }.compact.sort.uniq
  end

  private

  def read_names
    display_names = []
    pattern = "#{start_points_dir}/**/manifest.json"
    Dir.glob(pattern).each do |manifest_filename|
      json = JSON.parse!(IO.read(manifest_filename))
      display_names << json['display_name']
    end
    display_names.sort
  end

  # - - - - - - - - - - - - - - - - - - - -

  def read_manifests
    manifests = {}
    pattern = "#{start_points_dir}/**/manifest.json"
    Dir.glob(pattern).each do |manifest_filename|
      manifest = JSON.parse!(IO.read(manifest_filename))
      display_name = manifest['display_name']
      visible_filenames = manifest['visible_filenames']
      dir = File.dirname(manifest_filename)
      manifest['visible_files'] = Hash[
        visible_filenames.map { |filename|
          [ filename, { 'content' => IO.read("#{dir}/#{filename}") } ]
        }
      ]
      manifest.delete('visible_filenames')
      fe = manifest['filename_extension']
      manifest['filename_extension'] = [ fe ] if fe.is_a?(String)
      manifests[display_name] = manifest
    end
    manifests
  end

  # - - - - - - - - - - - - - - - - - - - -

  def start_points_dir
    '/app/repos'
  end

  # - - - - - - - - - - - - - - - - - - - -

  def error(name, diagnostic)
    raise ArgumentError.new("#{name}:#{diagnostic}")
  end

end
