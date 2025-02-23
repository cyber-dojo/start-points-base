require_relative '../src/rack_dispatcher'
require_relative 'rack_request_stub'
require_relative 'test_base'

class RackDispatcherTest < TestBase

  def self.hex_prefix
    'D06'
  end

  # - - - - - - - - - - - - - - - - -

  test 'BB0',
  %w( unknown method-name becomes exception ) do
    body,stderr = assert_rack_call_raw(400, 'blah', '{}')
    assert_exception('ClientError', 'json:malformed', body, stderr)

    body,stderr = assert_rack_call_raw(400, 'Start_points', '{}')
    assert_exception('ClientError', 'json:malformed', body, stderr)

    body,stderr = assert_rack_call_raw(400, 'a b', '{}')
    assert_exception('ClientError', 'json:malformed', body, stderr)
  end

  # - - - - - - - - - - - - - - - - -

  test 'BB1',
  %w( invalid json in http payload becomes exception ) do
    body,stderr = assert_rack_call_raw(500, 'start_points', 'sdfsdf')
    assert_exception('JSON::ParserError', "unexpected character: 'sdfsdf'", body, stderr)

    body,stderr = assert_rack_call_raw(500, 'start_points', 'nil')
    assert_exception('JSON::ParserError', "unexpected token at 'nil'", body, stderr)
  end

  # - - - - - - - - - - - - - - - - -

  test 'BB2',
  %w( non-hash in http payload becomes exception ) do
    body,stderr = assert_rack_call_raw(400, 'start_points', 'null')
    assert_exception('ClientError', 'json:malformed', body, stderr)

    body,stderr = assert_rack_call_raw(400, 'start_points', '[]')
    assert_exception('ClientError', 'json:malformed', body, stderr)
  end

  # - - - - - - - - - - - - - - - - -

  test 'BB3',
  %w( treat '' as {} for liveness/readyness http probes ) do
    body,stderr = assert_rack_call_raw(200, 'ready', '')
    assert_equal({}, stderr)
    assert_equal({"ready?"=> true}, body)
  end

end
