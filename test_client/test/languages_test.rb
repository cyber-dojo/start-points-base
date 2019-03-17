require_relative 'test_base'

class LanguagesTest < TestBase

  def self.hex_prefix
    '444'
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '190', %w( sha looks like a sha ) do
    sha = languages.sha
    assert_equal 40, sha.size
    sha.each_char do |ch|
      assert "0123456789abcdef".include?(ch)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '602', %w( its ready ) do
    assert languages.ready?
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '9C1',
  %w( names are unique and sorted ) do
    assert_equal expected_names.sort, languages.names
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '71D',
  %w( manifests ) do
    manifests = languages.manifests
    assert manifests.is_a?(Hash)
    assert_equal expected_names.sort, manifests.keys.sort
    manifest = manifests['C#, NUnit']
    assert_is_CSharp_NUnit_manifest(manifest)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '8C0',
  %w( unknown method raises ) do
    error = assert_raises(ServiceError) {
      languages.wibble
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
      languages.manifest(42)
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
      languages.manifest(nil)
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
      languages.manifest('xxx')
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
      'C#, NUnit',
      'Python, unittest',
      'Ruby, MiniTest'
    ]
  end

  # - - - - - - - - - - - - - - - - - - - -

  def assert_is_CSharp_NUnit_manifest(manifest)
    expected_keys = %w( display_name filename_extension
      hidden_filenames image_name visible_files )
    assert_equal expected_keys.sort, manifest.keys.sort

    assert_equal 'C#, NUnit', manifest['display_name']
    assert_equal ['.cs'], manifest['filename_extension']
    assert_equal 'cyberdojofoundation/csharp_nunit', manifest['image_name']
    expected_filenames = %w( Hiker.cs HikerTest.cs cyber-dojo.sh )
    visible_files = manifest['visible_files']
    assert_equal expected_filenames, visible_files.keys.sort
    assert_starts_with(visible_files, 'Hiker.cs', 'public class Hiker')
    assert_starts_with(visible_files, 'HikerTest.cs', 'using NUnit.Framework;')
    assert_starts_with(visible_files, 'cyber-dojo.sh', 'NUNIT_PATH=/nunit/lib/net45')
  end

end
