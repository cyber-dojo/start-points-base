require_relative 'test_base'

class ApiTest < TestBase

  def self.hex_prefix
    '477'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '190', %w( sha looks like a sha ) do
    body,stderr = sha(200)
    assert_equal({}, stderr)
    sha = body['sha']
    assert_equal 40, sha.size, body
    sha.each_char do |ch|
      assert "0123456789abcdef".include?(ch)
    end
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '602', %w( its ready ) do
    body,stderr = ready?(200)
    assert_equal({}, stderr)
    result = body['ready?']
    assert_equal true, result, body
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '6C1',
  %w( names are unique and sorted ) do
    body,stderr = names(200)
    assert_equal({}, stderr)
    actual_names = body['names']
    assert_equal expected_names.sort, actual_names.sort
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '71D',
  %w( manifests ) do
    body,stderr = manifests(200)
    assert_equal({}, stderr)
    manifests = body['manifests']
    assert manifests.is_a?(Hash)
    assert_equal expected_names.sort, manifests.keys.sort
    manifest = manifests['Yahtzee refactoring, C# NUnit']
    assert_is_Yahtzee_refactoring_CSharp_NUnit_manifest(manifest)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C0',
  %w( manifest with missing name becomes exception ) do
    body,stderr = assert_rack_call_raw(500, 'manifest', '{}')
    assert_exception('ArgumentError', 'name:missing', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C1',
  %w( manifest with non-string name becomes exception ) do
    body,stderr = manifest(500, 42)
    assert_exception('ArgumentError', 'name:!string', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C2',
  %w( manifest with unknown name becomes exception ) do
    body,stderr = manifest(500, 'xxx, C# NUnit')
    assert_exception('ArgumentError', 'name:xxx, C# NUnit:unknown', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '9C3',
  %w( manifest with known name ) do
    body,stderr = manifest(200, 'Yahtzee refactoring, C# NUnit')
    assert_equal({}, stderr)
    manifest = body['manifest']
    assert_is_Yahtzee_refactoring_CSharp_NUnit_manifest(manifest)
  end


  private

  def expected_names
    [
      'Yahtzee refactoring, C# NUnit',
      'Yahtzee refactoring, C (gcc) assert',
      'Yahtzee refactoring, C++ (g++) assert',
      'Yahtzee refactoring, Java JUnit',
      'Yahtzee refactoring, Python unitttest'
    ]
  end

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
