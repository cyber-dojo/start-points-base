
def shas_filename
  '/app/repos/shas.txt'
end

def root_dir
  ARGV[0]
end

puts "root_dir==#{root_dir}"
puts `ls -al #{root_dir}`

puts "shas"
puts `cat #{root_dir}/shas.txt`
