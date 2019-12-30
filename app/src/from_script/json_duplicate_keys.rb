require 'json'

module JsonDuplicateKeys

  def json_duplicate_keys(doc)
    JSON.parse(doc, { object_class:JsonDuplicateKeyErrorRaiser })
    {}
  rescue JsonDuplicateKeyError => e
    { 'key' => e.key, 'values' => e.values }
  end

  def json_pretty_duplicate_keys(h)
    [ "{",
        debracketed(h['key'], h['values'][0]) + ",",
        debracketed(h['key'], h['values'][1]),
      "}"
    ].join("\n")
  end

  def debracketed(key, value)
    JSON.pretty_generate({ key => value })[2..-3]
  end

  class JsonDuplicateKeyErrorRaiser
    def initialize
      @entries = {}
    end
    def []=(key, value)
      seen(key, value)
      if duplicate?(key)
        raise JsonDuplicateKeyError.new(key, values(key))
      end
    end
    private
    def seen(key, value)
      entries[key] ||= []
      entries[key] << value
    end
    def duplicate?(key)
      entries[key].size == 2
    end
    def values(key)
      entries[key]
    end
    attr_reader :entries
  end

  class JsonDuplicateKeyError < RuntimeError
    def initialize(key, values)
      @key = key
      @values = values
    end
    attr_reader :key, :values
  end

end
