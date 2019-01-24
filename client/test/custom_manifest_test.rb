require_relative 'test_base'

class CustomManifestTest < TestBase

  def self.hex_prefix
    'AE7'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '3CC',
  %w( valid display_name with one optional property ) do
    manifest = custom_manifest('Yahtzee refactoring, Java JUnit')

    expected_keys = %w(
      display_name image_name visible_files filename_extension
    )
    assert_equal expected_keys.sort, manifest.keys.sort

    assert_equal 'Yahtzee refactoring, Java JUnit', manifest['display_name']
    assert_equal ['.java'], manifest['filename_extension']
    assert_equal 'cyberdojofoundation/java_junit', manifest['image_name']
    expected_filenames = %w( Yahtzee.java YahtzeeTest.java cyber-dojo.sh instructions )
    assert_equal expected_filenames, manifest['visible_files'].keys.sort
  end

end
