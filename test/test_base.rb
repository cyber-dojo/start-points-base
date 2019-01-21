require_relative 'hex_mini_test'
require_relative 'rack_request_stub'
require_relative '../src/rack_dispatcher'
require 'json'

class TestBase < HexMiniTest

  def rack
    @rack ||= RackDispatcher.new(RackRequestStub)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def sha(status)
    assert_rack_call_raw(status, 'sha', '{}')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def language_start_points(status)
    assert_rack_call_raw(status, 'language_start_points', '{}')
  end

  def language_manifest(status, display_name, exercise_name)
    args = {
      display_name:display_name,
      exercise_name:exercise_name
    }
    raw = JSON.pretty_generate(args)
    assert_rack_call_raw(status, 'language_manifest', raw)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def custom_start_points(status)
    assert_rack_call_raw(status, 'custom_start_points', '{}')
  end

  def custom_manifest(status, display_name)
    args = { display_name:display_name }
    raw = JSON.pretty_generate(args)
    assert_rack_call_raw(status, 'custom_manifest', raw)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_rack_call_raw(status, path_info, args)
    env = { body:args, path_info:path_info }
    response,stderr = with_captured_stderr { rack.call(env) }
    assert_equal status, response[0]
    assert_equal({ 'Content-Type' => 'application/json' }, response[1])
    body = JSON.parse(response[2][0])
    stderr = (stderr == '') ? {} : JSON.parse(stderr)
    return [ body, stderr ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def with_captured_stderr
    begin
      old_stderr = $stderr
      $stderr = StringIO.new('', 'w')
      response = yield
      return [ response, $stderr.string ]
    ensure
      $stderr = old_stderr
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_exception(class_name, message_name, body, stderr)
    [body,stderr].each do |s|
      ex = s['exception']
      assert_equal class_name, ex['class'], s
      assert_equal message_name, ex['message'], s
      assert_equal 'Array', ex['backtrace'].class.name, s
    end
  end

end
