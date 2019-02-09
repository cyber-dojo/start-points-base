require_relative 'read_manifest_filenames'
require 'json'

class ExerciseManifestChecker

  def initialize(root_dir, type)
    @type = type
    @manifest_filenames = read_manifest_filenames(root_dir, type)
  end

  def check_all
    @manifest_filenames.each do |url,filenames|
      check_one(url, filenames)
    end
  end

  private

  def check_one(url, filenames)
    filenames.each do |filename|
      content = IO.read(filename)
      begin
        json = JSON.parse!(content)
      rescue JSON::ParserError => error
        STDERR.puts('ERROR: bad JSON in manifest.json file')
        STDERR.puts("--#{@type} #{url}")
        STDERR.puts("filename='#{filename}'")
        STDERR.puts(error)
        exit(17)
      end
    end
  end

end
