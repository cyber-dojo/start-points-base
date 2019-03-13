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

end
