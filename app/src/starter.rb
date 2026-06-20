require 'json'

class Starter

  def initialize
    @names = read_names
    @manifests, @manifests_by_raw_name = self.class.lookups_from(load_manifests)
  end

  def alive?
    true
  end

  def ready?
    true
  end

  def sha
    ENV['SHA']
  end

  attr_reader :names, :manifests

  def manifest(name)
    unless name.is_a?(String)
      error('name', '!string')
    end
    result = self.class.find(name, manifests, @manifests_by_raw_name)
    if result.nil?
      error('name', "#{name}:unknown")
    end
    result
  end

  def image_names
    manifests.map{ |_,manifest| manifest['image_name'] }.compact.sort.uniq
  end

  # Returns names in the same order as jsons (names[i] is the name for
  # jsons[i]). If every manifest carries both a language and a
  # test_framework [name,version] pair AND the resulting "language-name,
  # test_framework-name" strings are all unique, each name is built from
  # the pair-names (dropping versions); otherwise every name falls back to
  # its raw display_name.
  def self.names_for(jsons)
    if jsons.all? { |j| j.key?('language') && j.key?('test_framework') }
      constructed = jsons.map { |j| "#{j['language'][0]}, #{j['test_framework'][0]}" }
      return constructed if constructed.uniq.size == constructed.size
    end
    jsons.map { |j| j['display_name'] }
  end

  # Builds the sorted list of names (see names_for for the construction rule).
  def self.names_from(jsons)
    names_for(jsons).sort
  end

  # Returns the manifests keyed by name (see names_for for the construction
  # rule), overwriting each manifest's display_name field to match its key.
  def self.manifests_from(manifests)
    names = names_for(manifests)
    result = {}
    manifests.each_with_index do |manifest, i|
      manifest['display_name'] = names[i]
      result[names[i]] = manifest
    end
    result
  end

  # Builds the two lookup maps for manifest(name) from the loaded manifests:
  # by_constructed (the chosen names from names_for, == the manifests() keys)
  # and by_raw (each manifest's original display_name). by_raw must be captured
  # before manifests_from overwrites display_name. Returns [by_constructed, by_raw].
  def self.lookups_from(manifests)
    by_raw = manifests.each_with_object({}) { |m, h| h[m['display_name']] = m }
    by_constructed = manifests_from(manifests)
    [by_constructed, by_raw]
  end

  # Resolves name to its manifest: a constructed name (key of by_constructed)
  # matches first; otherwise a raw display_name (key of by_raw). nil if neither.
  def self.find(name, by_constructed, by_raw)
    by_constructed[name] || by_raw[name]
  end

  private

  def read_names
    pattern = "#{start_points_dir}/**/manifest.json"
    jsons = Dir.glob(pattern).map { |f| JSON.parse!(IO.read(f)) }
    self.class.names_from(jsons)
  end

  def load_manifests
    manifests = []
    pattern = "#{start_points_dir}/**/manifest.json"
    Dir.glob(pattern).each do |manifest_filename|
      manifest = JSON.parse!(IO.read(manifest_filename))
      dir = File.dirname(manifest_filename)
      visible_filenames = manifest['visible_filenames']
      manifest['visible_files'] = Hash[
        visible_filenames.map { |filename|
          [ filename, { 'content' => IO.read("#{dir}/#{filename}") } ]
        }
      ]
      manifest.delete('visible_filenames')
      fe = manifest['filename_extension']
      manifest['filename_extension'] = [ fe ] if fe.is_a?(String)
      if manifest.key?('rag_lambda')
        filename = manifest['rag_lambda']
        manifest['rag_lambda'] = IO.read("#{dir}/#{filename}")
      end
      manifests << manifest
    end
    manifests
  end

  def start_points_dir
    '/app/repos'
  end

  def error(name, diagnostic)
    raise ArgumentError.new("#{name}:#{diagnostic}")
  end

end
