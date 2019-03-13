require_relative 'show_error'

module CheckDisplayNames

  include ShowError

  def check_display_names(display_names, error_code)
    display_names.each do |display_name,locations|
      if locations.size > 1
        STDERR.puts('ERROR: display_name duplicate')
        locations.each do |url,filename|
          STDERR.puts("--#{@type} #{url}")
          STDERR.puts("manifest='#{relative(filename)}'")
          STDERR.puts("\"display_name\": \"#{display_name}\"")
        end
        exit(error_code)
      end
    end
  end

end
