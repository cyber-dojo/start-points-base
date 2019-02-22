#!/usr/bin/ruby

require 'json'

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
  peturn_language_manifest('Display_name', 'C#, NUnit')
end

def exercise_manifest_has_unknown_key
  peturn_exercise_manifest('Display_name', 'C#, NUnit')
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_missing_display_name
  peturn_language_manifest('display_name', nil)
end

def exercises_manifest_missing_display_name
  peturn_exercise_manifest('display_name', nil)
end

def languages_manifest_missing_visible_filenames
  peturn_language_manifest('visible_filenames', nil)
end

def languages_manifest_missing_image_name
  peturn_language_manifest('image_name', nil)
end

def languages_manifest_missing_filename_extension
  peturn_language_manifest('filename_extension', nil)
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_non_string_image_name
  peturn_language_manifest('image_name', [1,2,3])
end

def languages_manifest_has_malformed_image_name
  value = 'CYBERDOJO/csharp_nunit'
  peturn_language_manifest('image_name', value)
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_non_string_display_name
  peturn_language_manifest('display_name', [1,2,3])
end

def exercises_manifest_has_non_string_display_name
  peturn_exercise_manifest('display_name', [1,2,3])
end

def languages_manifest_has_empty_display_name
  peturn_language_manifest('display_name', '')
end

def exercises_manifest_has_empty_display_name
  peturn_exercise_manifest('display_name', '')
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_non_array_visible_filenames
  peturn_language_manifest('visible_filenames', 1)
end

def exercises_manifest_has_non_array_visible_filenames
  peturn_exercise_manifest('visible_filenames', 1)
end

def languages_manifest_has_empty_visible_filenames
  peturn_language_manifest('visible_filenames', [])
end

def languages_manifest_has_non_array_string_visible_filenames
  peturn_language_manifest('visible_filenames', [1,2,3])
end

def languages_manifest_has_empty_string_visible_filename
  value = ["hiker.cs", ""]
  peturn_language_manifest('visible_filenames', value)
end

def languages_manifest_visible_filename_has_non_portable_character
  value = ["hiker.cs","hiker&.cs"]
  peturn_language_manifest('visible_filenames', value)
end

def languages_manifest_visible_filename_has_non_portable_leading_character
  value = ["-hiker.cs","hiker.test.cs"]
  peturn_language_manifest('visible_filenames', value)
end

def languages_manifest_visible_filename_has_duplicates
  value = ["a.cs", "b.cs", "c.cs", "b.cs"]
  peturn_language_manifest('visible_filenames', value)
end

def languages_manifest_visible_filename_does_not_exist
  value = [ 'HikerTest.cs', 'xHiker.cs', 'cyber-dojo.sh' ]
  peturn_language_manifest('visible_filenames', value)
end

def languages_manifest_visible_filename_no_cyber_dojo_sh
  value = [ 'HikerTest.cs', 'Hiker.cs' ]
  peturn_language_manifest('visible_filenames', value)
end

def languages_manifest_visible_file_too_large
  value = [ 'tiny.cs', 'large.cs', 'small.cs' ]
  peturn_language_manifest('visible_filenames', value)
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    dir = File.dirname(manifest_filename)
    IO.write("#{dir}/tiny.cs", 'tiny')
    IO.write("#{dir}/small.cs", 'small')
    IO.write("#{dir}/large.cs", 'L'*(1024*25+1))
    break
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_filename_extension_is_int
  peturn_language_manifest('filename_extension', 1)
end

def languages_manifest_filename_extension_is_int_array
  peturn_language_manifest('filename_extension', [1,2,3])
end

def languages_manifest_filename_extension_is_empty_array
  peturn_language_manifest('filename_extension', [])
end

def languages_manifest_filename_extension_is_empty_string
  peturn_language_manifest('filename_extension', '')
end

def languages_manifest_filename_extension_is_dotless
  peturn_language_manifest('filename_extension', 'cs')
end

def languages_manifest_filename_extension_is_only_dot
  peturn_language_manifest('filename_extension', '.')
end

def languages_manifest_filename_extension_duplicates
  value = [".cs", ".h", ".c", ".h"]
  peturn_language_manifest('filename_extension', value)
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_hidden_filenames_success
  value = [ "coverage/\\.last_run\\.json" ]
  peturn_language_manifest('hidden_filenames', value)
end

def languages_manifest_hidden_filenames_int
  peturn_language_manifest('hidden_filenames', 1)
end

def languages_manifest_hidden_filenames_int_array
  peturn_language_manifest('hidden_filenames', [1,2,3])
end

def languages_manifest_hidden_filenames_empty_array
  peturn_language_manifest('hidden_filenames', [])
end

def languages_manifest_hidden_filenames_empty_string
  peturn_language_manifest('hidden_filenames', [''])
end

def languages_manifest_hidden_filenames_bad_regex
  peturn_language_manifest('hidden_filenames', ['('])
end

def languages_manifest_hidden_filenames_duplicate
  peturn_language_manifest('hidden_filenames', ['sd','gg','sd'])
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_tab_size_smallest_int
  peturn_language_manifest('tab_size', 1)
end

def languages_manifest_tab_size_biggest_int
  peturn_language_manifest('tab_size', 8)
end

def languages_manifest_tab_size_string
  peturn_language_manifest('tab_size', '6')
end

def languages_manifest_tab_size_int_too_small
  peturn_language_manifest('tab_size', 0)
end

def languages_manifest_tab_size_int_too_large
  peturn_language_manifest('tab_size', 9)
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_max_seconds_smallest_int
  peturn_language_manifest('max_seconds', 1)
end

def languages_manifest_max_seconds_biggest_int
  peturn_language_manifest('max_seconds', 20)
end

def languages_manifest_max_seconds_string
  peturn_language_manifest('max_seconds', '6')
end

def languages_manifest_max_seconds_int_too_small
  peturn_language_manifest('max_seconds', 0)
end

def languages_manifest_max_seconds_int_too_large
  peturn_language_manifest('max_seconds', 21)
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_highlight_filenames_success
  peturn_language_manifest('highlight_filenames', ['HikerTest.cs'])
end

def languages_manifest_highlight_filenames_int
  peturn_language_manifest('highlight_filenames', 42)
end

def languages_manifest_highlight_filenames_int_array
  peturn_language_manifest('highlight_filenames', [42])
end

def languages_manifest_highlight_filenames_empty_array
  peturn_language_manifest('highlight_filenames', [])
end

def languages_manifest_highlight_filenames_empty_string
  peturn_language_manifest('highlight_filenames', [''])
end

def languages_manifest_highlight_filenames_not_visible
  peturn_language_manifest('highlight_filenames', ['Hiker.cs','xx.cs'])
end

def languages_manifest_highlight_filenames_duplicates
  peturn_language_manifest('highlight_filenames', ['Hiker.cs','HikerTest.cs', 'Hiker.cs'])
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_progress_regexs_success
  value = [ "FAILED \\(failures=\\d+\\)", "OK" ]
  peturn_language_manifest('progress_regexs', value)
end

def languages_manifest_progress_regexs_int
  peturn_language_manifest('progress_regexs', 6)
end

def languages_manifest_progress_regexs_string
  peturn_language_manifest('progress_regexs', '6')
end

def languages_manifest_progress_regexs_int_array
  peturn_language_manifest('progress_regexs', [1,2])
end

def languages_manifest_progress_regexs_empty_array
  peturn_language_manifest('progress_regexs', [])
end

def languages_manifest_progress_regexs_bad_regex
  peturn_language_manifest('progress_regexs', ['OK','('])
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_display_names_duplicate_1
  peturn_language_manifest('display_name', 'Dup')
end

def languages_manifest_has_display_names_duplicate_2
  peturn_language_manifest('display_name', 'Dup', 'languages-python-unittest')
end

def exercises_manifest_has_display_names_duplicate_1
  peturn_exercise_manifest('display_name', 'Dup')
end

def exercises_manifest_has_display_names_duplicate_2
  peturn_exercise_manifest('display_name', 'Dup', 'exercises-tiny-maze')
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_runner_choice_stateless
  peturn_language_manifest('runner_choice', 'stateless')
end

# - - - - - - - - - - - - - - - - - - - - - - -

def peturn_language_manifest(key, value, dir_name = 'languages-csharp-nunit')
  `cp -R /app/#{dir_name} #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    json = JSON.parse!(IO.read(manifest_filename))
    if value.nil?
      json.delete(key)
    else
      json[key] = value
    end
    IO.write(manifest_filename, JSON.pretty_generate(json))
    break
  end
end

def peturn_exercise_manifest(key, value, dir_name = 'exercises-fizz-buzz')
  `cp -R /app/#{dir_name} #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    json = JSON.parse!(IO.read(manifest_filename))
    if value.nil?
      json.delete(key)
    else
      json[key] = value
    end
    IO.write(manifest_filename, JSON.pretty_generate(json))
    break
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

eval(data_set_name)
