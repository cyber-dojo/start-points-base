require_relative 'coverage'
require_relative 'json_duplicate_keys'
require 'minitest/autorun'

class TestJsonDuplicateKeys < MiniTest::Test

  include JsonDuplicateKeys

  def test_empty_hash_when_no_duplicate_keys
    doc = '{ "x":"hello", "y":[1,2,3] }'
    actual = json_duplicate_keys(doc)
    assert_equal({}, actual)
  end

  def test_non_empty_hash_when_duplicate_keys
    doc = '{ "x":"hello", "x":[1,2,3] }'
    actual = json_duplicate_keys(doc)
    expected = {
      'key' => 'x',
      'values' => ['hello',[1,2,3]]
    }
    assert_equal expected, actual
  end

  def test_json_prettified_string
    doc = '{ "x":"hello", "x":[1,2,3] }'
    h = json_duplicate_keys(doc)
    actual = json_pretty_duplicate_keys(h)
    expected = [
      '{',
      '  "x": "hello",',
      '  "x": [',
      '    1,',
      '    2,',
      '    3',
      '  ]',
      '}'
    ].join("\n")
    assert_equal expected, actual
  end

end
