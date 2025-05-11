require_relative 'coverage'
require_relative 'json_duplicate_keys'
require 'minitest/autorun'

class TestJsonDuplicateKeys < Minitest::Test

  include JsonDuplicateKeys

  def test_empty_hash_when_no_duplicate_keys
    doc = '{ "x":"hello", "y":[1,2,3] }'
    actual = json_duplicate_keys(doc)
    assert_equal [], actual
  end

  def test_non_empty_hash_when_duplicate_keys
    doc = '{ "x":"hello", "x":[1,2,3] }'
    actual = json_duplicate_keys(doc)
    assert_equal ["x"], actual
  end

end
