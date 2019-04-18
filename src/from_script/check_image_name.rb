require_relative 'show_error'
require_relative 'well_formed_image_name'

module CheckImageName

  include ShowError
  include WellFormedImageName

  def check_image_name(url, filename, json, error_code)
    ok = json['image_name']
    ok &&= image_name_is_string(url, filename, json, error_code)
    ok &&= image_name_is_well_formed(url, filename, json, error_code)
  end

  # - - - - - - - - - - - - - - - - - - - -

  def image_name_is_string(url, filename, json, error_code)
    result = true
    image_name = json['image_name']
    unless image_name.is_a?(String)
      title = 'image_name is not a String'
      key = quoted('image_name')
      msg = "#{key}: #{image_name}"
      result = error(title, url, filename, msg, error_code)
    end
    result
  end

  # - - - - - - - - - - - - - - - - - - - -

  def image_name_is_well_formed(url, filename, json, error_code)
    image_name = json['image_name']
    unless well_formed_image_name?(image_name)
      title = 'image_name is malformed'
      key = quoted('image_name')
      msg = "#{key}: #{quoted(image_name)}"
      error(title, url, filename, msg, error_code)
    end
  end

end
