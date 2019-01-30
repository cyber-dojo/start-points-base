#!/usr/bin/ruby

def data_set_name
  ARGV[1]
end

def target_dir
  ARGV[2]
end

puts "Hello from Ruby #{data_set_name}, #{target_dir}"
