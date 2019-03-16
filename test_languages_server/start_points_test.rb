require_relative 'test_base'

class StartPointsTest < TestBase

  def self.hex_prefix
    'F4D'
  end

  # - - - - - - - - - - - - - - - - - - - -

  test '0F4',
  %w( display-names ) do
    body,stderr = start_points(200)
    assert_equal({}, stderr)
    start_points = body['start_points']
    expected = [ 'Ruby, MiniTest', 'C#, NUnit', 'Python, unittest' ]
    assert_equal expected.sort, start_points.sort, body
  end

end
