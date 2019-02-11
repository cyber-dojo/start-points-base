require_relative 'show_error'
require_relative 'well_formed_image_name'

module CheckImageName

  include ShowError
  include WellFormedImageName

  def check_image_name(url, filename, json)
    image_name = json['image_name']
    unless image_name.is_a?(String)
      title = 'image_name is not a String'
      msg = "\"image_name\": #{image_name}"
      show_error(title, url, filename, msg)
      exit(21)
    end
    unless well_formed_image_name?(image_name)
      title = 'image_name is malformed'
      msg = "\"image_name\": \"#{image_name}\""
      show_error(title, url, filename, msg)
      exit(22)
    end
  end

end
