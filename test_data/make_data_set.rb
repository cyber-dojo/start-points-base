#!/usr/bin/ruby

def data_set_name
  ARGV[0]
end

def target_dir
  ARGV[1]
end

# - - - - - - - - - - - - - - - - - - - - - - -

def custom_no_manifests
  `cp -R /app/custom-yahtzee #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

def exercises_no_manifests
  `cp -R /app/exercises-bowling-game #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

def languages_no_manifests
  `cp -R /app/languages-ruby-minitest #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_bad_json
  `cp -R /app/languages-python-unittest #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    IO.write(manifest_filename, 'sdfsdf')
    break
  end
end

def exercises_bad_json
  `cp -R /app/exercises-bowling-game #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    IO.write(manifest_filename, 'ggghhhjjj')
    break
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_duplicate_keys
  `cp -R /app/languages-csharp-nunit #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    manifest = <<~MANIFEST.strip
    {
      "display_name": "C#, NUnit",
      "display_name": "C#, JUnit",
      "visible_filenames": [
        "HikerTest.cs",
        "Hiker.cs",
        "cyber-dojo.sh"
      ],
      "hidden_filenames": [ "TestResult\\.xml" ],
      "image_name": "cyberdojofoundation/csharp_nunit",
      "runner_choice": "stateless",
      "filename_extension": ".cs"
    }
    MANIFEST
    IO.write(manifest_filename, manifest)
    break
  end
end

def exercises_manifest_has_duplicate_keys
  `cp -R /app/exercises-leap-years #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    manifest = <<~MANIFEST
    {
      "display_name": "Leap Years",
      "display_name": "Years Leap"
    }
    MANIFEST
    IO.write(manifest_filename, manifest)
    break
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_unknown_key
  `cp -R /app/languages-csharp-nunit #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    manifest = <<~MANIFEST.strip
    {
      "Display_name": "C#, NUnit",
      "visible_filenames": [
        "HikerTest.cs",
        "Hiker.cs",
        "cyber-dojo.sh"
      ],
      "hidden_filenames": [ "TestResult\\.xml" ],
      "image_name": "cyberdojofoundation/csharp_nunit",
      "runner_choice": "stateless",
      "filename_extension": ".cs"
    }
    MANIFEST
    IO.write(manifest_filename, manifest)
    break
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

eval(data_set_name)
