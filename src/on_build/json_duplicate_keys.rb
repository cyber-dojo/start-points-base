require 'json'

def json_duplicate_keys(doc)
  JSON.parse(doc, { object_class:JsonDuplicateKeyErrorRaiser })
  {}
rescue JsonDuplicateKeyError => error
  { 'key' => error.key, 'duplicates' => error.duplicates }
end

def json_pretty_duplicate_keys(key, duplicates)
  one = JSON.pretty_generate({ key => duplicates[0] })
  two = JSON.pretty_generate({ key => duplicates[1] })
  "{\n" + one[2..-3] + ",\n" + two[2..-3] + "\n}"
end

class JsonDuplicateKeyErrorRaiser
  def initialize
    @entries = {}
  end
  def []=(key, value)
    seen(key, value)
    if duplicate?(key)
      raise JsonDuplicateKeyError.new(key, duplicates(key))
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
  def duplicates(key)
    entries[key]
  end
  attr_reader :entries
end

class JsonDuplicateKeyError < RuntimeError
  def initialize(key, duplicates)
    @key = key
    @duplicates = duplicates
  end
  attr_reader :key, :duplicates
end
