require_relative 'test_base'

class CustomManifestTest < TestBase

  def self.hex_prefix
    'F49'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C0',
  %w( missing display_name becomes exception ) do
    body,stderr = assert_rack_call_raw(500, 'custom_manifest', '{}')
    assert_exception('ArgumentError', 'display_name:missing', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C1',
  %w( non-string display_name becomes exception ) do
    body,stderr = custom_manifest(500, 42)
    assert_exception('ArgumentError', 'display_name:!string', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C2',
  %w( unknown display_name becomes exception ) do
    body,stderr = custom_manifest(500, 'xxx, C# NUnit')
    assert_exception('ArgumentError', 'display_name:xxx, C# NUnit:unknown', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C3',
  %w( valid display_name ) do
    body,stderr = custom_manifest(200, 'Yahtzee refactoring, C# NUnit')
    assert_equal({}, stderr)
    manifest = body['custom_manifest']

    expected_keys = %w(
      display_name image_name visible_files filename_extension
    )
    assert_equal expected_keys.sort, manifest.keys.sort

    assert_equal 'Yahtzee refactoring, C# NUnit', manifest['display_name']
    assert_equal ['.cs'], manifest['filename_extension']
    assert_equal 'cyberdojofoundation/csharp_nunit', manifest['image_name']
    expected_filenames = %w( Yahtzee.cs YahtzeeTest.cs cyber-dojo.sh instructions )
    assert_equal expected_filenames, manifest['visible_files'].keys.sort
  end

end
