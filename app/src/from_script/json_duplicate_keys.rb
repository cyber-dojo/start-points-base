require 'json'

module JsonDuplicateKeys

  def json_duplicate_keys(doc)
    json.loads(doc, object_pairs_hook=validate_data)
    []
  rescue JsonDuplicateKeys => e
    e.keys
#     obj = JSON.parse(doc, { object_class:JsonKeyCollector })
#     all_keys = obj.all_keys
#     all_keys.select{ |e| all_keys.count(e) > 1 }.uniq.sort
  end

  def validate_data(list_of_pairs)
    key_count = collections.Counter(k for k,v in list_of_pairs)
    duplicate_keys = ', '.join(k for k,v in key_count.items() if v>1)
    if len(duplicate_keys) != 0:
        raise ValueError('Duplicate key(s) found: {}'.format(duplicate_keys))

  class JsonDuplicateKeys < ValueError
    def initialize(keys)
      @keys = keys
    end
    attr_reader :keys
  end

#   def json_pretty_duplicate_keys(h)
#     [ "{",
#         debracketed(h['key'], h['values'][0]) + ",",
#         debracketed(h['key'], h['values'][1]),
#       "}"
#     ].join("\n")
#   end
#
#   def debracketed(key, value)
#     JSON.pretty_generate({ key => value })[2..-3]
#   end

  class JsonKeyCollector < Hash
    def initialize
      #super
      @keys = []
    end

    alias old_brackets []=

    def []=(key, value)
      p("...[]=(#{key},#{value})")
      # old_brackets(key, value)
      @keys << key
    end

    def all_keys
      @keys
    end

  end

end
