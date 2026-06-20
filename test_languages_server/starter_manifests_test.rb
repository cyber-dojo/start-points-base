require_relative 'hex_mini_test'
require_relative '../src/starter'

class StarterManifestsTest < HexMiniTest

  # When every manifest has both a language and a test_framework
  # [name,version] pair, and the constructed "name, framework" strings
  # are all unique, each manifest is keyed by its constructed name and
  # its display_name field is overwritten to match (versions dropped).
  test 'D2F001',
  %w( all manifests have unique pairs so each is keyed and named by its pair-names ) do
    java = { 'display_name' => 'Java 21, JUnit 5',
             'image_name' => 'cyberdojofoundation/java_junit',
             'language' => ['Java', '21'], 'test_framework' => ['JUnit', '5'] }
    csharp = { 'display_name' => 'C# 12, NUnit 4',
               'image_name' => 'cyberdojofoundation/csharp_nunit',
               'language' => ['C#', '12'], 'test_framework' => ['NUnit', '4'] }
    result = Starter.manifests_from([java, csharp])
    assert_equal ['C#, NUnit', 'Java, JUnit'], result.keys.sort
    assert_equal 'Java, JUnit', result['Java, JUnit']['display_name']
    assert_equal 'C#, NUnit',   result['C#, NUnit']['display_name']
    assert_equal 'cyberdojofoundation/java_junit', result['Java, JUnit']['image_name']
  end

  # When any manifest lacks a test_framework pair, all manifests fall
  # back to being keyed and named by their raw display_name.
  test 'D2F002',
  %w( one manifest missing test_framework so all keyed by raw display_name ) do
    java = { 'display_name' => 'Java 21, JUnit 5',
             'language' => ['Java', '21'], 'test_framework' => ['JUnit', '5'] }
    csharp = { 'display_name' => 'C# 12, NUnit 4',
               'language' => ['C#', '12'] }
    result = Starter.manifests_from([java, csharp])
    assert_equal ['C# 12, NUnit 4', 'Java 21, JUnit 5'], result.keys.sort
    assert_equal 'Java 21, JUnit 5', result['Java 21, JUnit 5']['display_name']
  end

  # When any manifest lacks a language pair, all manifests fall back to
  # being keyed and named by their raw display_name.
  test 'D2F003',
  %w( one manifest missing language so all keyed by raw display_name ) do
    java = { 'display_name' => 'Java 21, JUnit 5',
             'test_framework' => ['JUnit', '5'] }
    csharp = { 'display_name' => 'C# 12, NUnit 4',
               'language' => ['C#', '12'], 'test_framework' => ['NUnit', '4'] }
    result = Starter.manifests_from([java, csharp])
    assert_equal ['C# 12, NUnit 4', 'Java 21, JUnit 5'], result.keys.sort
    assert_equal 'C# 12, NUnit 4', result['C# 12, NUnit 4']['display_name']
  end

  # When every manifest has both pairs but two construct to the same
  # "name, framework" string, all manifests fall back to being keyed and
  # named by their raw display_name.
  test 'D2F004',
  %w( duplicate constructed names so all keyed by raw display_name ) do
    older = { 'display_name' => 'Ruby 3.4, MiniTest 5.20',
              'language' => ['Ruby', '3.4'], 'test_framework' => ['MiniTest', '5.20'] }
    newer = { 'display_name' => 'Ruby 4.0, MiniTest 5.25',
              'language' => ['Ruby', '4.0'], 'test_framework' => ['MiniTest', '5.25'] }
    result = Starter.manifests_from([older, newer])
    assert_equal ['Ruby 3.4, MiniTest 5.20', 'Ruby 4.0, MiniTest 5.25'], result.keys.sort
    assert_equal 'Ruby 3.4, MiniTest 5.20', result['Ruby 3.4, MiniTest 5.20']['display_name']
  end

end
