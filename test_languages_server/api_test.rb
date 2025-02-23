require_relative 'test_base'

class ApiTest < TestBase

  def self.hex_prefix
    'FB3'
  end

  # - - - - - - - - - - - - - - - - -

  test '601', %w( its alive  ) do
    body,stderr = alive?(200)
    assert_equal({}, stderr)
    result = body['alive?']
    assert_equal true, result, body
  end

  # - - - - - - - - - - - - - - - - -

  test '602', %w( its ready  ) do
    body,stderr = ready?(200)
    assert_equal({}, stderr)
    result = body['ready?']
    assert_equal true, result, body
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

  # - - - - - - - - - - - - - - - - - - - -

  test '191', %w( base_image looks like a base_image ) do
    body,stderr = base_image(200)
    assert_equal({}, stderr)
    base_image = body['base_image']
    assert base_image =~ /cyberdojo\/start-points-base:[0-9a-f]{7}/
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
    manifest = manifests['C#, NUnit']
    assert_is_CSharp_NUnit_manifest(manifest)
  end

  # - - - - - - - - - - - - - - - - -

  test 'D7A',
  %w( manifest with missing name becomes exception ) do
    body,stderr = assert_rack_call_raw(500, 'manifest', '{}')
    assert_exception('ArgumentError', 'name:missing', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7B',
  %w( manifest with non-string name becomes exception ) do
    body,stderr = manifest(500, 42)
    assert_exception('ArgumentError', 'name:!string', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7C',
  %w( manifest with unknown name becomes exception ) do
    body,stderr = manifest(500, 'xxx')
    assert_exception('ArgumentError', 'name:xxx:unknown', body, stderr)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'D7E',
  %w( manifest with known name ) do
    body,stderr = manifest(200, 'C#, NUnit')
    assert_equal({}, stderr)
    manifest = body['manifest']
    assert_is_CSharp_NUnit_manifest(manifest)
  end

  # - - - - - - - - - - - - - - - - - - - -

  test 'EE4',
  %w( image_names ) do
    expected = %w(
      cyberdojofoundation/csharp_nunit
      cyberdojofoundation/python_unittest
      cyberdojofoundation/ruby_mini_test
    )
    body,stderr = image_names(200)
    assert_equal({}, stderr)
    assert_equal expected, body['image_names']
  end

  private

  def expected_names
    [ 'C#, NUnit', 'Python, unittest', 'Ruby, MiniTest' ]
  end

  def assert_is_CSharp_NUnit_manifest(manifest)
    expected_keys = %w(
      display_name visible_files image_name
      hidden_filenames filename_extension
    )
    assert_equal expected_keys.sort, manifest.keys.sort
    assert_equal 'C#, NUnit', manifest['display_name']
    assert_equal ['.cs'], manifest['filename_extension']
    assert_equal 'cyberdojofoundation/csharp_nunit', manifest['image_name']
    expected_filenames = %w( Hiker.cs HikerTest.cs cyber-dojo.sh )
    visible_files = manifest['visible_files']
    assert_equal expected_filenames, manifest['visible_files'].keys.sort
    assert_starts_with(visible_files, 'Hiker.cs', 'public class Hiker')
    assert_starts_with(visible_files, 'HikerTest.cs', 'using NUnit.Framework;')
    assert_starts_with(visible_files, 'cyber-dojo.sh', 'NUNIT_PATH=/nunit/lib/net45')
  end

  def assert_starts_with(visible_files, filename, content)
    actual = visible_files[filename]['content']
    diagnostic = [
      "filename:#{filename}",
      "expected:#{content}:",
      "  actual:#{actual.split[0]}:"
    ].join("\n")
    assert actual.start_with?(content), diagnostic
  end

end
