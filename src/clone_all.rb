
repo_names = IO.read(ARGV[0]).split.map!(&:strip)
repo_names.each_with_index do |repo_name, index|
  name = repo_name.split('/')[-1]
  `git clone --depth 1 #{repo_name} #{index}/#{name}`
  # process it as per [cyber-dojo start-point create]
end
