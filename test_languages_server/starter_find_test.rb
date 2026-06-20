require_relative 'hex_mini_test'
require_relative '../src/starter'

class StarterFindTest < HexMiniTest

  def self.hex_prefix
    'E4B'
  end

  # In construction mode (every manifest has unique pairs) manifest(name)
  # resolves a constructed display_name to its manifest.
  test '01',
  %w( constructed display_name resolves in construction mode ) do
    by_constructed, by_raw = Starter.lookups_from(construction_manifests)
    found = Starter.find('Java, JUnit', by_constructed, by_raw)
    assert_equal 'cyberdojofoundation/java_junit', found['image_name']
  end

  # In construction mode, a name that is not a constructed display_name
  # falls back to matching a raw (versioned) display_name.
  test '02',
  %w( raw display_name resolves as a fallback in construction mode ) do
    by_constructed, by_raw = Starter.lookups_from(construction_manifests)
    found = Starter.find('Java 21, JUnit 5', by_constructed, by_raw)
    assert_equal 'cyberdojofoundation/java_junit', found['image_name']
  end

  # A name matching neither a constructed nor a raw display_name resolves
  # to nil.
  test '03',
  %w( unknown name resolves to nil ) do
    by_constructed, by_raw = Starter.lookups_from(construction_manifests)
    assert_nil Starter.find('No Such Thing', by_constructed, by_raw)
  end

  # In fallback mode (a manifest lacks its pairs) there are no constructed
  # display_names, so manifest(name) resolves only raw display_names.
  test '04',
  %w( fallback mode resolves raw display_name and not a constructed one ) do
    by_constructed, by_raw = Starter.lookups_from(fallback_manifests)
    found = Starter.find('Java 21, JUnit 5', by_constructed, by_raw)
    assert_equal 'cyberdojofoundation/java_junit', found['image_name']
    assert_nil Starter.find('Java, JUnit', by_constructed, by_raw)
  end

  private

  # Two manifests that both carry unique language/test_framework pairs, so
  # names_for constructs version-less names for them.
  def construction_manifests
    [
      { 'display_name' => 'Java 21, JUnit 5',
        'image_name' => 'cyberdojofoundation/java_junit',
        'language' => ['Java', '21'], 'test_framework' => ['JUnit', '5'] },
      { 'display_name' => 'C# 12, NUnit 4',
        'image_name' => 'cyberdojofoundation/csharp_nunit',
        'language' => ['C#', '12'], 'test_framework' => ['NUnit', '4'] },
    ]
  end

  # Like construction_manifests but the C# manifest lacks its test_framework
  # pair, so names_for falls every manifest back to its raw display_name.
  def fallback_manifests
    [
      { 'display_name' => 'Java 21, JUnit 5',
        'image_name' => 'cyberdojofoundation/java_junit',
        'language' => ['Java', '21'], 'test_framework' => ['JUnit', '5'] },
      { 'display_name' => 'C# 12, NUnit 4',
        'image_name' => 'cyberdojofoundation/csharp_nunit',
        'language' => ['C#', '12'] },
    ]
  end

end
