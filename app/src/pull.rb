require_relative 'image_name'
require_relative 'starter'

existing_image_names = `docker image ls --format "{{.Repository}}:{{.Tag}}"`.split("\n").sort.uniq

current_image_names =
  Starter.new.image_names.map do |image_name|
    tagless,tag = Docker::image_name_tag_split(image_name)
    if tag === ''
      "#{tagless}:latest"
    else
      "#{tagless}:#{tag}"
    end
  end

present_image_names = current_image_names & existing_image_names
missing_image_names = current_image_names - existing_image_names

puts 'image pulling...'
puts "#{present_image_names.size} already present..."
present_image_names.each do |image_name|
  puts image_name
end
puts
puts "#{missing_image_names.size} need pulling..."
missing_image_names.each do |image_name|
  command = "docker pull #{image_name}"
  puts command
  `#{command}`
end
