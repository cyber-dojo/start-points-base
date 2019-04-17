
module ShowError

  def error(title, url, filename, msg, error_code)
    show_error(title, url, filename, msg)
    @error_codes << error_code
    false
  end

  def show_error(title, url, filename, msg = '')
    stream = STDERR
    stream.puts("ERROR: #{title}")
    stream.puts("--#{@type} #{url}")
    stream.puts("manifest='#{relative(filename)}'")
    unless msg.empty?
      stream.puts(msg)
    end
    stream.flush
  end

  def relative(filename)
    # eg '/app/repos/3/languages-python-unittest/start_point/manifest.json'
    parts = filename.split('/')
    parts[4..-1].join('/')
    # eg 'languages-python-unittest/start_point/manifest.json'
  end

end
