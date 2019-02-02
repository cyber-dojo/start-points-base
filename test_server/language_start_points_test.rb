require_relative 'test_base'

class LanguageStartPointsTest < TestBase

  def self.hex_prefix
    'F4D'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '0F4',
  %w( display-names ) do
    body,stderr = language_start_points(200)
    assert_equal({}, stderr)
    start_points = body['language_start_points']
    expected = [ 'Ruby, MiniTest', 'C#, NUnit', 'Python, unittest' ]
    assert_equal expected.sort, start_points['languages'].sort, body
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '0F5',
  %w( exercise-names ) do
    body,stderr = language_start_points(200)
    assert_equal({}, stderr)
    start_points = body['language_start_points']
    expected = [
      'Bowling Game',
      'Fizz Buzz',
      'Leap Years',
      'Tiny Maze'
    ]
    assert_equal expected, start_points['exercises'].keys.sort, body
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '0F6',
  %w( instructions ) do
    body,stderr = language_start_points(200)
    assert_equal({}, stderr)
    @start_points = body['language_start_points']

    expected = 'Write a program to score a game of Ten-Pin Bowling.'
    assert_line('Bowling Game', expected)

    expected = 'Write a program that prints the numbers from 1 to 100.'
    assert_line('Fizz Buzz', expected)

    expected = 'Write a function that returns true or false depending on '
    assert_line('Leap Years', expected)

    expected = 'Alice found herself very tiny and wandering around Wonderland.'
    assert_line('Tiny Maze', expected)
  end

  # - - - - - - - - - - - - - - - - - - - -

  def assert_line(name, expected)
    instructions = @start_points['exercises'][name]['content']
    lines = instructions.split("\n")
    assert instructions.start_with?(expected), lines[0]
  end

end
