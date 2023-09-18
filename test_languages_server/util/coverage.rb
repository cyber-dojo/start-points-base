require 'simplecov'
require_relative 'simplecov_json'

cov_root = File.expand_path('../..', __dir__)
SimpleCov.start do
  # add_group('debug') { |code| print(code.filename+"\n"); false }
  add_group( 'src') { | src|  src.filename.start_with?("#{cov_root}/src" ) }
  add_group('test') { |test| test.filename.start_with?("#{cov_root}/test") }
end
SimpleCov.root(cov_root)
SimpleCov.coverage_dir(ENV['COVERAGE_ROOT'])
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter
])
