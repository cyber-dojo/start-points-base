require 'json'
require 'json/stream'

module JsonDuplicateKeys

  def json_duplicate_keys(doc)
    parser = JSON::Stream::Parser.new
    builder = MyBuilder.new(parser)
    parser << doc
    builder.duplicate_keys
  end

  # https://www.rubydoc.info/gems/json-stream/0.2.1/JSON/Stream/Builder
  class MyBuilder < JSON::Stream::Builder

    def initialize(parser)
      super(parser)
      @level = 0
      @keys = []
    end

    def duplicate_keys
      @keys.select{ |e| @keys.count(e) > 1}.uniq.sort
    end

    def key(key)
      super
      @keys << key if @level == 1
    end

    def start_object
      super
      @level += 1
    end

    def end_object
      super
      @level -= 1
    end

  end

end
