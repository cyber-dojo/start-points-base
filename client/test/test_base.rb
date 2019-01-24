require_relative 'hex_mini_test'
require_relative '../src/starter_service'
require 'json'

class TestBase < HexMiniTest

  def starter
    StarterService.new
  end

  # - - - - - - - - - - - - - - - - - -

  def language_start_points
    starter.language_start_points
  end

  def language_manifest(display_name, exercise_name)
    starter.language_manifest(display_name, exercise_name)
  end

  # - - - - - - - - - - - - - - - - - -

  def custom_start_points
    starter.custom_start_points
  end

  def custom_manifest(display_name)
    starter.custom_manifest(display_name)
  end

end
