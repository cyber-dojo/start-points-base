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

  class JsonDuplicateKeyErrorRaiser < Hash
    def initialize(*)
      super
      @dup_entries = {}
    end

    alias old_brackets []=

    def []=(key, value)
      old_brackets(key, value)
      seen(key, value)
      if has_key?(key)
        raise JsonDuplicateKeyError.new(key, dup_values(key))
      end
    end

    private

    def seen(key, value)
      dup_entries[key] ||= []
      dup_entries[key] << value
    end

    def dup_values(key)
      dup_entries[key]
    end

    attr_reader :dup_entries
  end

  class JsonDuplicateKeyError < RuntimeError
    def initialize(key, values)
      @key = key
      @values = values
    end
    attr_reader :key, :values
  end

end
