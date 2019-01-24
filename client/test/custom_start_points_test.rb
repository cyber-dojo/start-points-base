require_relative 'test_base'

class CustomStartPointsTest < TestBase

  def self.hex_prefix
    '9E6'
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '9C1',
  %w( display-names are unique and sorted ) do
    expected = [
      'Yahtzee refactoring, C (gcc) assert',
      'Yahtzee refactoring, C# NUnit',
      'Yahtzee refactoring, C++ (g++) assert',
      'Yahtzee refactoring, Java JUnit',
      'Yahtzee refactoring, Python unitttest'
    ]
    assert_equal expected.sort, custom_start_points.sort
  end

end
