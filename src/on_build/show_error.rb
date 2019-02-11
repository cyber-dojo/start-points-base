
module ShowError

  def show_error(title, url, filename, msg = '')
    STDERR.puts("ERROR: #{title}")
    STDERR.puts("--#{@type} #{url}")
    STDERR.puts("manifest='#{relative(filename)}'")
    unless msg.empty?
      STDERR.puts(msg)
    end
  end

  def relative(filename)
    # eg '/app/repos/languages/3/languages-python-unittest/start_point/manifest.json'
    parts = filename.split('/')
    parts[5..-1].join('/')
    # eg 'languages-python-unittest/start_point/manifest.json'
  end

end
