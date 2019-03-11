require_relative 'client_error'
require_relative 'starter_custom'
require_relative 'starter_exercises'
require_relative 'starter_languages'
require 'json'

class RackDispatcher

  def initialize(request)
    @request = request
    if ENV['SERVER_TYPE'] == '--custom'
      @starter = StarterCustom.new
    end
    if ENV['SERVER_TYPE'] == '--exercises'
      @starter = StarterExercises.new
    end
    if ENV['SERVER_TYPE'] == '--languages'
      @starter = StarterLanguages.new
    end
  end

  def call(env)
    request = @request.new(env)
    path = request.path_info[1..-1] # lose leading /
    body = request.body.read
    name, args = validated_name_args(path, body)
    result = @starter.public_send(name, *args)
    json_response(200, plain({ name => result }))
  rescue Exception => error
    diagnostic = pretty({
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

  def validated_name_args(name, body)
    @args = JSON.parse(body)
    args = case name
      when /^ready$/          then []
      when /^sha$/            then []
      when /^start_points$/   then []
      when /^manifest$/       then [display_name]
      else
        raise ClientError, 'json:malformed'
    end
    name += '?' if query?(name)
    [name, args]
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

  def plain(body)
    JSON.generate(body)
  end

  def pretty(body)
    JSON.pretty_generate(body)
  end

  def query?(name)
    ['ready'].include?(name)
  end

  # - - - - - - - - - - - - - - - -
  # method arguments
  # - - - - - - - - - - - - - - - -

  def display_name
    argument(__method__.to_s)
  end

  # - - - - - - - - - - - - - - - -
  # validations
  # - - - - - - - - - - - - - - - -

  def argument(name)
    unless @args.key?(name)
      raise ArgumentError.new("#{name}:missing")
    end
    @args[name]
  end

end
