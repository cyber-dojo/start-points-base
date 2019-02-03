#!/usr/bin/ruby

def data_set_name
  ARGV[0]
end

def target_dir
  ARGV[1]
end

def custom_no_manifests
  `cp -R /app/custom-yahtzee #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

def exercises_no_manifests
  `cp -R /app/exercises-bowling-game #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

def ltf_no_manifests
  `cp -R /app/ltf-ruby-minitest #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

eval(data_set_name)
