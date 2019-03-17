require_relative 'test_base'

class ErrorTest < TestBase

  def self.hex_prefix
    'B72'
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test 'BD0',
  %w( bad arguments ) do
    error = assert_raises(ServiceError) {
      starter.language_manifest('C#, NUnit', nil)
    }
    assert_equal 'HttpHelper', error.service_name
    assert_equal 'language_manifest', error.method_name
    json = JSON.parse(error.message)
    assert_equal 'language_manifest', json['path']
    assert_equal '{"display_name":"C#, NUnit","exercise_name":null}', json['body']
    assert_equal 'ArgumentError', json['class']
    assert_equal 'exercise_name:!string', json['message']
    assert_equal 'Array', json['backtrace'].class.name
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test 'BD1',
  %w( bad method ) do
    error = assert_raises(ServiceError) {
      starter.wibble
    }
    assert_equal 'HttpHelper', error.service_name
    assert_equal 'wibble', error.method_name
    json = JSON.parse(error.message)
    assert_equal 'wibble', json['path']
    assert_equal '{}', json['body']
    assert_equal 'ClientError', json['class']
    assert_equal 'json:malformed', json['message']
    assert_equal 'Array', json['backtrace'].class.name
  end

end
