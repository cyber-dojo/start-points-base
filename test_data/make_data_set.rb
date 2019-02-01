#!/usr/bin/ruby

def data_set_name
  ARGV[0]
end

def target_dir
  ARGV[1]
end

def custom_repo_contains_no_manifests
  `cp -R /app/good_custom #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

puts(data_set_name)
eval(data_set_name)
