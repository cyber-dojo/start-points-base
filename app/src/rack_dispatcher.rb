require_relative 'client_error'
require_relative 'starter'
require 'json'

class RackDispatcher

  def initialize(request)
    @request = request
    @starter = Starter.new
  end

  def call(env)
    request = @request.new(env)
    path = request.path_info[1..-1] # lose leading /
    request.body.rewind
    body = request.body.read
    name, args = validated_name_args(path, body)
    result = @starter.public_send(name, *args)
    json_response(200, json_plain({ name => result }))
  rescue Exception => error
    diagnostic = json_pretty({
      'exception' => {
        'path' => path,
        'body' => body,
        'class' => error.class.name,
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    })
    $stderr.puts(diagnostic)
    $stderr.flush
    json_response(code(error), diagnostic)
  end

  private # = = = = = = = = = = = =

  def validated_name_args(method_name, body)
    @args = json_parse(body)
    args = case method_name
      when /^alive$/          then []
      when /^ready$/          then []
      when /^sha$/            then []
      when /^base_image$/     then []
      when /^image_names$/    then []
      when /^names$/          then []
      when /^manifests$/      then []
      when /^manifest$/       then [name]
      else
        raise ClientError, 'json:malformed'
    end
    if query?(method_name)
      method_name += '?'
    end
    [method_name, args]
  end

  # - - - - - - - - - - - - - - - -

  def json_response(status, body)
    [ status,
      { 'Content-Type' => 'application/json' },
      [ body ]
    ]
  end

  def code(error)
    if error.is_a?(ClientError)
      400
    else
      500
    end
  end

  def query?(name)
    %w( alive ready ).include?(name)
  end

  # - - - - - - - - - - - - - - - -

  def json_parse(body)
    if body === ''
      json = {}
    else
      json = JSON.parse(body)
    end
    unless json.is_a?(Hash)
      raise ClientError, 'json:malformed'
    end
    json
  end

  def json_plain(body)
    JSON.generate(body)
  end

  def json_pretty(body)
    JSON.pretty_generate(body)
  end

  # - - - - - - - - - - - - - - - -

  def name
    argument(__method__.to_s)
  end

  # - - - - - - - - - - - - - - - -

  def argument(name)
    unless @args.key?(name)
      raise ArgumentError.new("#{name}:missing")
    end
    @args[name]
  end

end
