require_relative 'service_error'
require_relative 'http'
require 'json'

class HttpHelper

  def initialize(parent, hostname, port)
    @parent = parent
    @hostname = hostname
    @port = port
  end

  def get(*args)
    call('get', calling_method_name, *args)
  end

  private

  # The name of the method that called get, which is also the name of the
  # endpoint being asked for. caller_locations answers it as a value, where
  # matching a backtrace string relies on a format ruby is free to change:
  # 3.4 moved from `name' to 'Class#name', which base_label sees past.
  def calling_method_name
    caller_locations(2, 1).first.base_label
  end

  def call(gp, method, *args)
    json = http.public_send(gp, @hostname, @port, method, args_hash(method, *args))
    fail_unless(method, 'bad json') { json.class.name == 'Hash' }
    exception = json['exception']
    fail_unless(method, pretty(exception)) { exception.nil? }
    fail_unless(method, 'no key') { json.key?(method) }
    json[method]
  end

  def args_hash(method, *args)
    # Uses reflection to create a hash of args where each key is
    # the parameter name. For example,
    #
    # def language_manifest(display_name, exercise_name)
    #   http.get
    # end
    #
    # Reflection sees the names of language_manifest()'s parameters are
    # 'display_name' and 'exercise_name' and so constructs the hash as
    # { 'display_name' => args[0], 'exercise_name' => args[1] }
    parameters = @parent.class.instance_method(method).parameters
    parameters.map
              .with_index { |parameter,index| [parameter[1], args[index]] }
              .to_h
  end

  def fail_unless(name, message, &block)
    unless block.call
      fail ServiceError.new(self.class.name, name, message)
    end
  end

  def pretty(json)
    JSON.pretty_generate(json)
  end

  def http
    Http.new
  end

end
