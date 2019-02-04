
# TODO: check for malformed image_name 

def image_name
  ARGV[0]
end

def error(status, message)
  STDERR.puts("ERROR: #{message}")
  exit(status)
end

if image_name == '--custom'
  error(4, '--custom requires preceding <image_name>')
end
if image_name == '--exercises'
  error(5, '--exercises requires preceding <image_name>')
end
if image_name == '--languages'
  error(6, '--languages requires preceding <image_name>')
end

custom_urls = []
exercise_urls = []
language_urls = []

type = ''
last_url = ''
ARGV[1..-1].each do |url|
  if ['--custom','--exercises','--languages'].include?(url)
    type = url
  elsif type == ''
    error(7, "<git-repo-url> #{url} without preceding --custom/--exercises/--languages")
  elsif type == '--custom'
    custom_urls << url
  elsif type == '--exercises'
    exercise_urls << url
  elsif type == '--languages'
    language_urls << url
  end
  last_url = url
end
if last_url == '--custom' && custom_urls == []
  error(8, '--custom requires at least one <git-repo-url>')
end
if last_url == '--exercises' && exercise_urls == []
  error(9, '--exercises requires at least one <git-repo-url>')
end
if last_url == '--languages' && language_urls == []
  error(10, '--languages requires at least one <git-repo-url>')
end

def exit_non_zero_if_duplicate_urls_for(status, type, urls)
  if urls.uniq.sort != urls.sort
    msg = "--#{type} duplicated git-repo-urls\n"
    urls.select{|url| urls.count(url) != 1}.uniq.each do |dup|
      msg += "#{dup}\n"
    end
    error(status, msg)
  end
end

exit_non_zero_if_duplicate_urls_for(11, 'custom'   ,   custom_urls)
exit_non_zero_if_duplicate_urls_for(12, 'exercises', exercise_urls)
exit_non_zero_if_duplicate_urls_for(13, 'languages', language_urls)

exit(0)
