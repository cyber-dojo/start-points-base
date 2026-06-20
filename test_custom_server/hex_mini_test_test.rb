require_relative 'test_base'

class HexMiniTestTest < TestBase

  test '898C80',
  'hex-test-id is available via environment variable' do
    assert_equal '898C80', ENV['CYBER_DOJO_HEX_TEST_ID']
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '89857B',
  'hex-test-id is available via a method',
  'and equals the full 6-digit hex id' do
    assert_equal '89857B', hex_test_id
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '89818F',
  'hex-test-name is available via a method' do
    assert_equal 'hex-test-name is available via a method', hex_test_name
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '898D30',
  'hex-test-name can be long',
  'and split over many',
  'comma separated lines',
  'and will automatically be',
  'joined with spaces' do
    expected = [
      'hex-test-name can be long',
      'and split over many',
      'comma separated lines',
      'and will automatically be',
      'joined with spaces'
    ].join(' ')
    assert_equal expected, hex_test_name
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '898D31', %w(
    hex-test-name can be long
    and split over many lines
    with %w syntax
    and will automatically be
    joined with spaces
  ) do
    expected = [
      'hex-test-name can be long',
      'and split over many lines',
      'with %w syntax',
      'and will automatically be',
      'joined with spaces'
    ].join(' ')
    assert_equal expected, hex_test_name
  end

end
