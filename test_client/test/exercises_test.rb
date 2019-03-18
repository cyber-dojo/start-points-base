require_relative 'test_base'

class ExercisesTest < TestBase

  def self.hex_prefix
    '949'
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '190', %w( sha looks like a sha ) do
    sha = exercises.sha
    assert_equal 40, sha.size
    sha.each_char do |ch|
      assert "0123456789abcdef".include?(ch)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '602', %w( its ready ) do
    assert exercises.ready?
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '9C1',
  %w( names are unique and sorted ) do
    assert_equal expected_names.sort, exercises.names
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '71D',
  %w( manifests ) do
    manifests = exercises.manifests
    assert manifests.is_a?(Hash)
    assert_equal expected_names.sort, manifests.keys.sort
    manifest = manifests['Gray Code']
    assert_is_Gray_Code_manifest(manifest)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C3',
  %w( manifest with known name ) do
    manifest = exercises.manifest('Gray Code')
    assert_is_Gray_Code_manifest(manifest)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '8C0',
  %w( unknown method raises ) do
    error = assert_raises(ServiceError) {
      exercises.wibble
    }
    assert_error(error, {
      path:'wibble',
      body:'{}',
      class:'ClientError',
      message:'json:malformed'
    })
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '8C1',
  %w( manifest with non-string (int) name becomes exception ) do
    error = assert_raises(ServiceError) {
      exercises.manifest(42)
    }
    assert_error(error, {
      path:'manifest',
      body:'{"name":42}',
      class:'ArgumentError',
      message:'name:!string'
    })
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '8C2',
  %w( manifest with non-string (nil) name becomes exception ) do
    error = assert_raises(ServiceError) {
      exercises.manifest(nil)
    }
    assert_error(error, {
      path:'manifest',
      body:'{"name":null}',
      class:'ArgumentError',
      message:'name:!string'
    })
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '8C3',
  %w( manifest with unknown name becomes exception ) do
    error = assert_raises(ServiceError) {
      exercises.manifest('xxx')
    }
    assert_error(error, {
      path:'manifest',
      body:'{"name":"xxx"}',
      class:'ArgumentError',
      message:'name:xxx:unknown'
    })
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

  # - - - - - - - - - - - - - - - - - - - -

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

end
