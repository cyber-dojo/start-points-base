require_relative 'test_base'

class ApiTest < TestBase

  def self.hex_prefix
    'FB3'
  end

  # - - - - - - - - - - - - - - - - -

  test '190', %w( sha looks like a sha ) do
    body,stderr = sha(200)
    assert_equal({}, stderr)
    sha = body['sha']
    assert_equal 40, sha.size, body
    sha.each_char do |ch|
      assert "0123456789abcdef".include?(ch)
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '602', %w( its ready ) do
    body,stderr = ready?(200)
    assert_equal({}, stderr)
    result = body['ready?']
    assert_equal true, result, body
  end

  # - - - - - - - - - - - - - - - - -

  test '6C1',
  %w( names are unique and sorted ) do
    body,stderr = names(200)
    assert_equal({}, stderr)
    actual_names = body['names']
    assert_equal expected_names.sort, actual_names
  end

  # - - - - - - - - - - - - - - - - -

  test '71D',
  %w( manifests ) do
    body,stderr = manifests(200)
    assert_equal({}, stderr)
    manifests = body['manifests']
    assert manifests.is_a?(Hash)
    assert_equal expected_names.sort, manifests.keys.sort
    manifest = manifests['Gray Code']
    assert_is_Gray_Code_manifest(manifest)
  end

  # - - - - - - - - - - - - - - - - -

  test 'D7A',
  %w( manifest with missing name becomes exception ) do
    body,stderr = assert_rack_call_raw(500, 'manifest', '{}')
    assert_exception('ArgumentError', 'name:missing', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7B',
  %w( manifest with non-string argument becomes exception ) do
    body,stderr = manifest(500, 42)
    assert_exception('ArgumentError', 'name:!string', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7E',
  %w( manifest with unknown name becomes exception ) do
    body,stderr = manifest(500, 'xxx')
    assert_exception('ArgumentError', 'name:xxx:unknown', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '751',
  %w( manifest with known name ) do
    body,stderr = manifest(200, 'Gray Code')
    assert_equal({}, stderr)
    manifest = body['manifest']
    assert_is_Gray_Code_manifest(manifest)
  end

  private

  def expected_names
    [
      'Bowling Game',
      'Calc Stats',
      'Fizz Buzz',
      'Gray Code',
      'Leap Years',
      'Tiny Maze'
    ]
  end

  def assert_is_Gray_Code_manifest(manifest)
    expected_keys = %w( display_name visible_files )
    assert_equal expected_keys.sort, manifest.keys.sort

    assert_equal 'Gray Code', manifest['display_name']
    expected_filenames = %w( larger.txt smaller.txt )
    visible_files = manifest['visible_files']
    assert_equal expected_filenames, visible_files.keys.sort
    assert_starts_with(visible_files, 'larger.txt', 'Create functions to')
    assert_starts_with(visible_files, 'smaller.txt', 'small content')
  end

  def assert_starts_with(visible_files, filename, content)
    actual = visible_files[filename]['content']
    diagnostic = [
      "filename:#{filename}",
      "expected:#{content}:",
      "--actual:#{actual.split[0]}:"
    ].join("\n")
    assert actual.start_with?(content), diagnostic
  end

end
