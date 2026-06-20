require_relative 'hex_mini_test'
require_relative '../src/starter'

class StarterNamesTest < HexMiniTest

  # When every manifest has both a language and a test_framework
  # [name,version] pair, and the constructed "name, framework" strings
  # are all unique, names are built from the pair-names only (versions
  # dropped) and returned sorted.
  test 'C7A001',
  %w( all manifests have unique pairs so names are constructed without versions ) do
    jsons = [
      { 'display_name' => 'Java 21, JUnit 5',
        'language' => ['Java', '21'], 'test_framework' => ['JUnit', '5'] },
      { 'display_name' => 'C# 12, NUnit 4',
        'language' => ['C#', '12'], 'test_framework' => ['NUnit', '4'] },
    ]
    assert_equal ['C#, NUnit', 'Java, JUnit'], Starter.names_from(jsons)
  end

  # When any manifest lacks a test_framework pair, all manifests fall
  # back to their raw display_name (which still carries the versions).
  test 'C7A002',
  %w( one manifest missing test_framework so all fall back to display_name ) do
    jsons = [
      { 'display_name' => 'Java 21, JUnit 5',
        'language' => ['Java', '21'], 'test_framework' => ['JUnit', '5'] },
      { 'display_name' => 'C# 12, NUnit 4',
        'language' => ['C#', '12'] },
    ]
    assert_equal ['C# 12, NUnit 4', 'Java 21, JUnit 5'], Starter.names_from(jsons)
  end

  # When any manifest lacks a language pair, all manifests fall back
  # to their raw display_name.
  test 'C7A003',
  %w( one manifest missing language so all fall back to display_name ) do
    jsons = [
      { 'display_name' => 'Java 21, JUnit 5',
        'test_framework' => ['JUnit', '5'] },
      { 'display_name' => 'C# 12, NUnit 4',
        'language' => ['C#', '12'], 'test_framework' => ['NUnit', '4'] },
    ]
    assert_equal ['C# 12, NUnit 4', 'Java 21, JUnit 5'], Starter.names_from(jsons)
  end

  # When every manifest has both pairs but two construct to the same
  # "name, framework" string, all manifests fall back to display_name.
  test 'C7A004',
  %w( duplicate constructed names so all fall back to display_name ) do
    jsons = [
      { 'display_name' => 'Ruby 3.4, MiniTest 5.20',
        'language' => ['Ruby', '3.4'], 'test_framework' => ['MiniTest', '5.20'] },
      { 'display_name' => 'Ruby 4.0, MiniTest 5.25',
        'language' => ['Ruby', '4.0'], 'test_framework' => ['MiniTest', '5.25'] },
    ]
    assert_equal ['Ruby 3.4, MiniTest 5.20', 'Ruby 4.0, MiniTest 5.25'],
                 Starter.names_from(jsons)
  end

end
