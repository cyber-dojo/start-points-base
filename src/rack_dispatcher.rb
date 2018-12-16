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
    name, args = validated_name_args(request)
    result = @starter.public_send(name, *args)
    json_response(200, { name => result })
  rescue Exception => error
    info = {
      'exception' => {
        'class' => error.class.name,
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    }
    $stderr.puts pretty(info)
    $stderr.flush
    json_response(status(error), info)
  end

  private # = = = = = = = = = = = =

  def validated_name_args(request)
    name = request.path_info[1..-1] # lose leading /
    @args = JSON.parse(request.body.read)
    args = case name
      when /^sha$/                   then []
      when /^language_start_points$/ then []
      when /^custom_start_points$/   then []
      when /^language_manifest$/     then [display_name,exercise_name]
      when /^custom_manifest$/       then [display_name]
      else
        raise ClientError, 'json:malformed'
    end
    [name, args]
  end

  # - - - - - - - - - - - - - - - -

  def json_response(status, body)
    [ status, { 'Content-Type' => 'application/json' }, [ pretty(body) ] ]
  end

  def pretty(o)
    JSON.pretty_generate(o)
  end

  def status(error)
    if error.is_a?(ClientError)
      400
    else
      500
    end
  end

  # - - - - - - - - - - - - - - - -
  # method arguments
  # - - - - - - - - - - - - - - - -

  def display_name
    argument(__method__.to_s)
  end

  def exercise_name
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
