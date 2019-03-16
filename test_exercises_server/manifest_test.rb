require_relative 'test_base'

class ManifestTest < TestBase

  def self.hex_prefix
    '3D9'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7A',
  %w( missing argument becomes exception ) do
    body,stderr = assert_rack_call_raw(500, 'manifest', '{}')
    assert_exception('ArgumentError', 'display_name:missing', body, stderr)

    body,stderr = assert_rack_call_raw(500, 'manifest', '{"name":42}')
    assert_exception('ArgumentError', 'display_name:missing', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7B',
  %w( non-string argument becomes exception ) do
    body,stderr = manifest(500, 42)
    assert_exception('ArgumentError', 'display_name:!string', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7E', %w( known display_name with single instructions visible_file) do
    body,stderr = manifest(200, 'Fizz Buzz')

    assert_equal({}, stderr)
    manifest = body['manifest']
    expected_keys = %w( display_name visible_files )
    assert_equal expected_keys.sort, manifest.keys.sort

    display_name = manifest['display_name']
    assert_equal 'Fizz Buzz', display_name
    visible_files = manifest['visible_files']
    assert_equal ['instructions'], visible_files.keys.sort

    instructions = visible_files['instructions']
    assert instructions['content'].start_with?('Write a program that prints')
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '751', %w( known display_name with single readme.txt visible_file ) do
    body,stderr = manifest(200, 'Calc Stats')

    assert_equal({}, stderr)
    manifest = body['manifest']
    expected_keys = %w( display_name visible_files )
    assert_equal expected_keys.sort, manifest.keys.sort

    display_name = manifest['display_name']
    assert_equal 'Calc Stats', display_name
    visible_files = manifest['visible_files']
    assert_equal ['readme.txt'], visible_files.keys.sort

    readme = visible_files['readme.txt']
    assert readme['content'].start_with?('Your task is to process')
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '752', %w( known display_name with two visible_files neither being instructions or readme.txt ) do
    body,stderr = manifest(200, 'Gray Code')

    assert_equal({}, stderr)
    manifest = body['manifest']
    expected_keys = %w( display_name visible_files )
    assert_equal expected_keys.sort, manifest.keys.sort

    display_name = manifest['display_name']
    assert_equal 'Gray Code', display_name
    visible_files = manifest['visible_files']
    assert_equal ['larger.txt','smaller.txt'], visible_files.keys.sort

    larger = visible_files['larger.txt']
    assert larger['content'].start_with?('Create functions')
    smaller = visible_files['smaller.txt']
    assert smaller['content'].start_with?('small content')
  end

end
