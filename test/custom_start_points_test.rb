require_relative 'test_base'

class CustomStartPointsTest < TestBase

  def self.hex_prefix
    '72110'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '6C1',
  %w( display-names are unique and sorted ) do
    body,stderr = custom_start_points(200)
    assert_equal({}, stderr)
    start_points = body['custom_start_points']
    expected = [
      'Yahtzee refactoring, C# NUnit',
      'Yahtzee refactoring, C (gcc) assert',
      'Yahtzee refactoring, C++ (g++) assert',
      'Yahtzee refactoring, Java JUnit',
      'Yahtzee refactoring, Python unitttest'
    ]
    assert_equal expected.sort, start_points.sort
  end

end
