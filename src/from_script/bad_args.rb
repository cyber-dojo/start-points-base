#!/usr/bin/ruby
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Checks command-line arguments passed to the main Bash script:
#   cyber_dojo_start_points_create.sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

require_relative 'well_formed_image_name'

include WellFormedImageName

def image_name
  ARGV[0]
end

def image_type
  ARGV[1]
end

def git_repo_urls
  ARGV[2..-1]
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def exit_non_zero_if_duplicate_urls_for(status, type)
  return if image_type != type
  urls = git_repo_urls
  if urls.uniq.sort != urls.sort
    msg = "#{type} duplicated git-repo-urls\n"
    urls.select{|url| urls.count(url) != 1}.uniq.each do |dup|
      msg += "#{dup}\n"
    end
    error(status, msg)
  end
end

def error(status, message)
  STDERR.puts("ERROR: #{message}")
  exit(status)
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

case image_name
when '--custom'    then error(4, '--custom requires preceding <image_name>')
when '--exercises' then error(5, '--exercises requires preceding <image_name>')
when '--languages' then error(6, '--languages requires preceding <image_name>')
end

unless ['--custom','--exercises','--languages'].include?(image_type)
  error(7, "<image-name> must be followed by one of --custom/--exercises/--languages")
end

if git_repo_urls == []
  case image_type
  when '--custom'    then error(8, '--custom requires at least one <git-repo-url>')
  when '--exercises' then error(9, '--exercises requires at least one <git-repo-url>')
  when '--languages' then error(10, '--languages requires at least one <git-repo-url>')
  end
end

exit_non_zero_if_duplicate_urls_for(11, '--custom'   )
exit_non_zero_if_duplicate_urls_for(12, '--exercises')
exit_non_zero_if_duplicate_urls_for(13, '--languages')

unless well_formed_image_name?(image_name)
  error(14, "malformed <image-name> #{image_name}")
end

exit(0)
