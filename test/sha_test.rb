require_relative 'test_base'

class ShaTest < TestBase

  def self.hex_prefix
    'FB359'
  end

  # - - - - - - - - - - - - - - - - -

  test '190', %w( sha is exposed via API ) do
    body,stderr = sha(200)
    assert_equal({}, stderr)
    sha = body['sha']
    assert_equal 40, sha.size
    sha.each_char do |ch|
      assert "0123456789abcdef".include?(ch)
    end
  end

end
