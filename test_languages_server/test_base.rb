require_relative 'hex_mini_test'
require_relative 'rack_request_stub'
require_relative '../src/rack_dispatcher'
require 'json'

class TestBase < HexMiniTest

  def rack
    @rack ||= RackDispatcher.new(RackRequestStub)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def alive?(status)
    assert_rack_call_raw(200, 'alive', '{}')
  end

  def ready?(status)
    assert_rack_call_raw(200, 'ready', '{}')
  end

  def sha(status)
    assert_rack_call_raw(status, 'sha', '{}')
  end

  # :nocov:
  def base_image(status)
    assert_rack_call_raw(status, 'base_image', '{}')
  end
  # :nocov:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def names(status)
    assert_rack_call_raw(status, 'names', '{}')
  end

  def manifests(status)
    assert_rack_call_raw(status, 'manifests', '{}')
  end

  def manifest(status, name)
    args = JSON.pretty_generate({ name:name })
    assert_rack_call_raw(status, 'manifest', args)
  end

  def image_names(status)
    assert_rack_call_raw(status, 'image_names', '{}')
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_rack_call_raw(status, path_info, args)
    env = { body:args, path_info:path_info }
    response,stderr = with_captured_stderr { rack.call(env) }
    assert_equal status, response[0], stderr
    assert_equal({ 'Content-Type' => 'application/json' }, response[1])
    body = JSON.parse(response[2][0])
    stderr = (stderr === '') ? {} : JSON.parse(stderr)
    [ body, stderr ]
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
