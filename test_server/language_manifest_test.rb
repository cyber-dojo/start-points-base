require_relative 'test_base'

class LanguageManifestTest < TestBase

  def self.hex_prefix
    '3D9'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7A',
  %w( missing argument becomes exception ) do
    body,stderr = assert_rack_call_raw(500, 'language_manifest', '{}')
    assert_exception('ArgumentError', 'display_name:missing', body, stderr)

    body,stderr = assert_rack_call_raw(500, 'language_manifest', '{"display_name":42}')
    assert_exception('ArgumentError', 'exercise_name:missing', body, stderr)

    body,stderr = assert_rack_call_raw(500, 'language_manifest', '{"exercise_name":42}')
    assert_exception('ArgumentError', 'display_name:missing', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7B',
  %w( non-string argument becomes exception ) do
    body,stderr = language_manifest(500, 42, 'Fizz Buzz')
    assert_exception('ArgumentError', 'display_name:!string', body, stderr)

    body,stderr = language_manifest(500, 'xxx', 42)
    assert_exception('ArgumentError', 'exercise_name:!string', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7C', %w( unknown display_name becomes exception ) do
    body,stderr = language_manifest(500, 'xxx, NUnit', 'Fizz Buzz')
    assert_exception('ArgumentError', 'display_name:xxx, NUnit:unknown', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7D', %w( unknown exercise_name becomes exception ) do
    body,stderr = language_manifest(500, 'C#, NUnit', 'xxx')
    assert_exception('ArgumentError', 'exercise_name:xxx:unknown', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7E', %w( valid with no optional properties ) do
    body,stderr = language_manifest(200, 'C#, NUnit', 'Fizz Buzz')

    assert_equal({}, stderr)
    result = body['language_manifest']

    manifest = result['manifest']
    expected_keys = %w(
      display_name filename_extension image_name visible_files
      hidden_filenames
    )
    assert_equal expected_keys.sort, manifest.keys.sort

    assert_equal 'C#, NUnit', manifest['display_name']
    assert_equal ['.cs'], manifest['filename_extension']
    assert_equal 'cyberdojofoundation/csharp_nunit', manifest['image_name']
    expected_filenames = %w( Hiker.cs HikerTest.cs cyber-dojo.sh )
    assert_equal expected_filenames, manifest['visible_files'].keys.sort

    instructions = result['exercise']
    assert instructions['content'].start_with?('Write a program that prints')
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7F', %w( valid with some optional properties ) do
    body,stderr = language_manifest(200, 'Python, unittest', 'Fizz Buzz')

    assert_equal({}, stderr)
    result = body['language_manifest']

    manifest = result['manifest']
    expected_keys = %w(
      display_name filename_extension hidden_filenames image_name
      progress_regexs tab_size visible_files
    )
    assert_equal expected_keys.sort, manifest.keys.sort

    assert_equal 'Python, unittest', manifest['display_name']
    assert_equal 'cyberdojofoundation/python_unittest', manifest['image_name']
    expected_filenames = %w( cyber-dojo.sh hiker.py test_hiker.py )
    assert_equal expected_filenames, manifest['visible_files'].keys.sort

    assert_equal [ '.py' ], manifest['filename_extension']
    assert_equal [ 'FAILED \\(failures=\\d+\\)', 'OK' ], manifest['progress_regexs']
    assert_equal 4, manifest['tab_size']

    instructions = result['exercise']
    assert instructions['content'].start_with?('Write a program that prints')
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '751', %w( exercise_manifest chooses readme.txt when no instructions ) do
    body,stderr = language_manifest(200, 'Python, unittest', 'Calc Stats')

    assert_equal({}, stderr)
    result = body['language_manifest']
    assert result['exercise']['content'].start_with?('Your task is to process')
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '752', %w( exercise_manifest chooses largest file when no readme.txt and no instructions ) do
    body,stderr = language_manifest(200, 'Python, unittest', 'Gray Code')

    assert_equal({}, stderr)
    result = body['language_manifest']
    assert result['exercise']['content'].start_with?('Create functions to encode')
  end

end
