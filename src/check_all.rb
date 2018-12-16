
def shas_filename
  '/app/shas.txt'
end

puts "CHECK IN #{ARGV[0]}"


#def repo_names
#  gets.chomp.split(/ /)
#end

=begin
repo_names.each_with_index do |repo_name, index|
  name = repo_name.split('/')[-1]
  #puts ":#{name}:"
  `git clone --verbose --depth 1 #{repo_name} #{index}/#{name}`

  # store shas (plural) ready for starter API-GET:sha
  sha=`cd #{index}/#{name} && git rev-parse HEAD`
  `echo #{sha} #{repo_name} >> #{shas_filename}`

  # process it as per [cyber-dojo start-point create]
end
=end
