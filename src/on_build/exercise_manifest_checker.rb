require_relative 'read_manifest_filenames'
require_relative 'clean_json'

class ExerciseManifestChecker

  def initialize(type)
    @type = type
  end

  def check_all(root_dir)
    filenames = read_manifest_filenames(root_dir, @type)
    filenames.each do |url,filenames|
      check_one(url, filenames)
    end
  end

  private

  include CleanJson

  def check_one(url, filenames)
    filenames.each do |filename|
      json = clean_json(url, filename)
      #...
    end
  end

end
