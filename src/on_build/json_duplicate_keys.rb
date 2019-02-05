require 'json'

class DuplicateKeyError < RuntimeError
  def initialize(key, duplicates)
    @key = key
    @duplicates = duplicates
  end
  attr_reader :key, :duplicates
end

class DuplicateKeyChecker
  def initialize
    @entries = {}
  end
  def []=(key, value)
    @entries[key] ||= []
    @entries[key] << value
    if @entries[key].size == 2
      fail DuplicateKeyError.new(key, @entries[key])
    end
  end
end

def json_duplicate_keys(doc)
  JSON.parser = JSON::Ext::Parser
  JSON.parse(doc, { object_class:DuplicateKeyChecker })
  return {}
rescue DuplicateKeyError => error
  return { "key" => error.key, "duplicates" => error.duplicates }
end

def json_pretty_duplicate_keys(key, duplicates)
  one = JSON.pretty_generate({ key => duplicates[0] })
  two = JSON.pretty_generate({ key => duplicates[1] })
  "{\n"+ one[2..-3] + ",\n" + two[2..-3] + "\n}"
end
