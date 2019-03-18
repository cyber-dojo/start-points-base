require_relative 'test_base'

class CustomTest < TestBase

  def self.hex_prefix
    '9E6'
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '190', %w( sha looks like a sha ) do
    sha = custom.sha
    assert_equal 40, sha.size
    sha.each_char do |ch|
      assert "0123456789abcdef".include?(ch)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '602', %w( its ready ) do
    assert custom.ready?
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '9C1',
  %w( names are unique and sorted ) do
    assert_equal expected_names.sort, custom.names
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '71D',
  %w( manifests ) do
    manifests = custom.manifests
    assert manifests.is_a?(Hash)
    assert_equal expected_names.sort, manifests.keys.sort
    manifest = manifests['Yahtzee refactoring, C# NUnit']
    assert_is_Yahtzee_refactoring_CSharp_NUnit_manifest(manifest)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '9C3',
  %w( manifest with known name ) do
    manifest = custom.manifest('Yahtzee refactoring, C# NUnit')
    assert_is_Yahtzee_refactoring_CSharp_NUnit_manifest(manifest)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '8C0',
  %w( unknown method raises ) do
    error = assert_raises(ServiceError) {
      custom.wibble
    }
    assert_error(error, {
      path:'wibble',
      body:'{}',
      class:'ClientError',
      message:'json:malformed'
    })
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '8C1',
  %w( manifest with non-string (int) name becomes exception ) do
    error = assert_raises(ServiceError) {
      custom.manifest(42)
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
      custom.manifest(nil)
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
      custom.manifest('xxx')
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
      'Yahtzee refactoring, C (gcc) assert',
      'Yahtzee refactoring, C# NUnit',
      'Yahtzee refactoring, C++ (g++) assert',
      'Yahtzee refactoring, Java JUnit',
      'Yahtzee refactoring, Python unitttest'
    ]
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def assert_is_Yahtzee_refactoring_CSharp_NUnit_manifest(manifest)
    expected_keys = %w( display_name image_name visible_files filename_extension )
    assert_equal expected_keys.sort, manifest.keys.sort

    assert_equal 'Yahtzee refactoring, C# NUnit', manifest['display_name']
    assert_equal ['.cs'], manifest['filename_extension']
    assert_equal 'cyberdojofoundation/csharp_nunit', manifest['image_name']
    expected_filenames = %w( Yahtzee.cs YahtzeeTest.cs cyber-dojo.sh instructions )
    visible_files = manifest['visible_files']
    assert_equal expected_filenames, visible_files.keys.sort
    assert_starts_with(visible_files, 'instructions', 'The starting code and tests')
    assert_starts_with(visible_files, 'Yahtzee.cs', 'public class Yahtzee {')
    assert_starts_with(visible_files, 'YahtzeeTest.cs', 'using NUnit.Framework;')
    assert_starts_with(visible_files, 'cyber-dojo.sh', 'NUNIT_PATH=/nunit/lib/net45')
  end

end
