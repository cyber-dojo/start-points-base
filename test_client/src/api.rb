
module Api

  def ready?
    http.get
  end

  def sha
    http.get
  end

  def names
    http.get
  end

  def manifests
    http.get
  end

  def manifest(name)
    http.get(name)
  end

end
