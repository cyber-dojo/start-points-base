require_relative 'json_duplicate_keys'
require 'minitest/autorun'

class TestJsonDuplicateKeys < MiniTest::Test

  def test_json_parse_no_duplicates
    doc = '{ "x":"hello", "y":[1,2,3] }'
    actual = json_duplicate_keys(doc)
    assert_equal({}, actual)
  end

  def test_json_parse_a_duplicate
    doc = '{ "x":"hello", "x":[1,2,3] }'
    actual = json_duplicate_keys(doc)
    expected = {
      'key' => 'x',
      'duplicates' => ['hello',[1,2,3]]
    }
    assert_equal expected, actual
  end

  def test_json_pretty_duplicate_keys
    doc = '{ "x":"hello", "x":[1,2,3] }'
    actual = json_duplicate_keys(doc)
    pretty = json_pretty_duplicate_keys(actual['key'], actual['duplicates'])
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
    assert_equal expected, pretty
  end

end
