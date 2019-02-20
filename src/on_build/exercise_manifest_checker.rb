require_relative 'read_manifest_filenames'
require_relative 'clean_json'

class ExerciseManifestChecker

  def initialize(type)
    @type = type
  end

  def check_all(root_dir)
    display_names = {}
    filenames = read_manifest_filenames(root_dir, @type)
    filenames.each do |url,filenames|
      check_one(url, filenames, display_names)
    end
  end

  private

  include CleanJson

  def check_one(url, filenames, display_names)
    filenames.each do |filename|
      json = clean_json(url, filename)
      #...check...
      #display_name = json['display_name']
      #display_names[display_name] ||= []
      #display_names[display_name] << [url,filename]      
    end
  end

end
