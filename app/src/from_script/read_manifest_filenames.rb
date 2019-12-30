
module ReadManifestFilenames

  def read_manifest_filenames(root_dir, type, error_code)
    result = {}
    lines = `cat #{root_dir}/shas.txt`.lines
    lines.each do |line|
      index,sha,url = line.split
      repo_dir_name = "#{root_dir}/#{index}"
      manifest_filenames = Dir.glob("#{repo_dir_name}/**/manifest.json")
      if manifest_filenames == []
        STDERR.puts('ERROR: no manifest.json files in')
        STDERR.puts("--#{type} #{url}")
        exit(error_code)
      else
        result[url] = manifest_filenames
      end
    end
    # map:key=url (string)
    # map:values=manifest_filenames (array of strings)
    result
  end

end
