require 'minitest/autorun'

class HexMiniTest < Minitest::Test

  @@args = (ARGV.sort.uniq - ['--']).map(&:upcase) # eg 2E4
  @@seen_hex_ids = []

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.test(hex_id, *lines, &test_block)
    hex_id = checked_hex_id(hex_id, lines)
    if @@args == [] || @@args.any?{ |arg| hex_id.include?(arg) }
      hex_name = lines.join(space = ' ')
      execute_around = lambda {
        _hex_setup_caller(hex_id, hex_name)
        begin
          self.instance_eval(&test_block)
        ensure
          puts $!.message unless $!.nil?
          _hex_teardown_caller
        end
      }
      name = "hex '#{hex_id}',\n'#{hex_name}'"
      define_method("test_\n#{name}".to_sym, &execute_around)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.checked_hex_id(hex_id, lines)
    method = "test '#{hex_id}',"
    pointer = ' ' * method.index("'") + '!'
    proposition = lines.join(space = ' ')
    pointee = ['',pointer,method,"'#{proposition}'",'',''].join("\n")
    pointer.prepend("\n\n")
    raise "#{pointer}empty#{pointee}" if hex_id == ''
    raise "#{pointer}not 6-digit hex#{pointee}" unless hex_id =~ /^[0-9A-F]{6}$/
    raise "#{pointer}duplicate#{pointee}" if @@seen_hex_ids.include?(hex_id)
    @@seen_hex_ids << hex_id
    hex_id
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def _hex_setup_caller(hex_id, hex_name)
    ENV['CYBER_DOJO_HEX_TEST_ID'] = hex_id
    @_hex_test_id = hex_id
    @_hex_test_name = hex_name
    hex_setup
  end

  def _hex_teardown_caller
    hex_teardown
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def hex_setup
  end

  def hex_teardown
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def hex_test_id
    @_hex_test_id
  end

  def hex_test_name
    @_hex_test_name
  end

end
