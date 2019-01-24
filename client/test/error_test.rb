require_relative 'test_base'

class ErrorTest < TestBase

  def self.hex_prefix
    'B72'
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test 'BD0',
  %w( bad arguments ) do
    error = assert_raises {
      starter.language_manifest('C#, NUnit', nil)
    }
    assert_equal 'ServiceError', error.class.name
    assert_equal 'StarterService', error.service_name
    assert_equal 'language_manifest', error.method_name
    json = JSON.parse(error.message)
    assert_equal 'ArgumentError', json['class']
    assert_equal 'exercise_name:!string', json['message']
    assert_equal 'Array', json['backtrace'].class.name
  end

end
