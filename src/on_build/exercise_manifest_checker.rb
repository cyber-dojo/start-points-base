require_relative 'read_manifest_filenames'
require 'json'

class ExerciseManifestChecker

  def initialize(root_dir, type)
    @manifest_filenames = read_manifest_filenames(root_dir, type)
    # map:key=url (string)
    # map:values=manifest_filenames (array of strings)
  end

  def check_all
  end

end
