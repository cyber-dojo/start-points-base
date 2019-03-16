require_relative 'test_base'

class StartPointsTest < TestBase

  def self.hex_prefix
    'F4D'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '0F5',
  %w( exercise-names ) do
    body,stderr = start_points(200)
    assert_equal({}, stderr)
    start_points = body['start_points']
    expected = [
      'Bowling Game',
      'Calc Stats',
      'Fizz Buzz',
      'Gray Code',
      'Leap Years',
      'Tiny Maze'
    ]
    assert_equal expected, start_points.keys.sort, body
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '0F6',
  %w( instructions ) do
    body,stderr = start_points(200)
    assert_equal({}, stderr)
    @start_points = body['start_points']

    expected = 'Write a program to score a game of Ten-Pin Bowling.'
    assert_line('Bowling Game', expected)

    expected = 'Your task is to process a sequence of integer numbers'
    assert_line('Calc Stats', expected)

    expected = 'Write a program that prints the numbers from 1 to 100.'
    assert_line('Fizz Buzz', expected)

    expected = 'Create functions to encode a number to and decode'
    assert_line('Gray Code', expected)

    expected = 'Write a function that returns true or false depending on '
    assert_line('Leap Years', expected)

    expected = 'Alice found herself very tiny and wandering around Wonderland.'
    assert_line('Tiny Maze', expected)
  end

  # - - - - - - - - - - - - - - - - - - - -

  def assert_line(name, expected)
    instructions = @start_points[name]['content']
    lines = instructions.split("\n")
    assert instructions.start_with?(expected), lines[0]
  end

end
