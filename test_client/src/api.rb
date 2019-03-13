
module Api

  def ready?
    http.get
  end

  def sha
    http.get
  end

  def start_points
    http.get
  end

  def manifest(display_name)
    http.get(display_name)
  end

end
