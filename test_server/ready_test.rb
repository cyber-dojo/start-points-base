require_relative 'test_base'

class ReadyTest < TestBase

  def self.hex_prefix
    '0B2'
  end

  # - - - - - - - - - - - - - - - - -

  test '602', %w( ready is exposed via API ) do
    body,stderr = ready?(200)
    assert_equal({}, stderr)
    result = body['ready?']
    assert_equal true, result, body
  end

end
