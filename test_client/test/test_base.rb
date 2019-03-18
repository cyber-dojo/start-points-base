require_relative 'hex_mini_test'
require_relative '../src/custom_service'
require_relative '../src/exercises_service'
require_relative '../src/languages_service'
require 'json'

class TestBase < HexMiniTest

  def custom
    CustomService.new
  end

  def exercises
    ExercisesService.new
  end

  def languages
    LanguagesService.new
  end

  # - - - - - - - - - - - - - - - - - - - -

  def assert_starts_with(visible_files, filename, content)
    actual = visible_files[filename]['content']
    diagnostic = [
      "filename:#{filename}",
      "expected:#{content}:",
      "--actual:#{actual.split[0]}:"
    ].join("\n")
    assert actual.start_with?(content), diagnostic
  end

  # - - - - - - - - - - - - - - - - - - - -

  def assert_error(error, expected)
    assert_equal 'HttpHelper', error.service_name
    assert_equal expected[:path], error.method_name
    json = JSON.parse(error.message)
    assert_equal expected[:path], json['path']
    assert_equal expected[:body], json['body']
    assert_equal expected[:class], json['class']
    assert_equal expected[:message], json['message']
    assert_equal 'Array', json['backtrace'].class.name
  end

end
