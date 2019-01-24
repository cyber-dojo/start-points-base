require_relative 'test_base'

class LanguageManifestTest < TestBase

  def self.hex_prefix
    'D47'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '266',
  %w( valid display_name,exercise_name with no optional properties ) do

    result = language_manifest('C#, NUnit', 'Fizz_Buzz')
    manifest = result['manifest']

    expected_keys = %w( display_name filename_extension
      hidden_filenames image_name visible_files )
    assert_equal expected_keys.sort, manifest.keys.sort

    assert_equal 'C#, NUnit', manifest['display_name']
    assert_equal ['.cs'], manifest['filename_extension']
    assert_equal 'cyberdojofoundation/csharp_nunit', manifest['image_name']
    expected_filenames = %w( Hiker.cs HikerTest.cs cyber-dojo.sh )
    assert_equal expected_filenames, manifest['visible_files'].keys.sort

    exercise = result['exercise']['content']
    assert exercise.start_with? 'Write a program that prints the numbers from 1 to 100'
  end

end
