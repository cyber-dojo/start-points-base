require 'simplecov'
require_relative 'simplecov_json'

cov_root = File.expand_path('../..', __dir__)
SimpleCov.start do
  # The default test_frameworks profile skips paths starting test/, which is
  # where this suite's tests live and which it measures the coverage of.
  filters.clear
  # group('debug') { |path| print(path.filename+"\n"); false }
  group( 'src') { |path| path.filename.start_with?("#{cov_root}/src" ) }
  group('test') { |path| path.filename.start_with?("#{cov_root}/test") }
end
SimpleCov.root(cov_root)
SimpleCov.coverage_dir(ENV['COVERAGE_ROOT'])
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  CoverageGroupsFormatter
])
