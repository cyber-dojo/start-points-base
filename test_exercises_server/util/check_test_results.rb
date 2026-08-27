require 'json'

def coverage_json
  $coverage_json = begin
    if ARGV[1].nil?
      fatal_error("ARGV[1] must be the path to the coverage json file")
    else
      JSON.parse(IO.read(ARGV[1]))  # eg /app/data/coverage.json
    end
  end
end

def fatal_error(message)
  puts message
  exit(42)
end

def number
  '[\.|\d]+'
end

def f2(s)
  result = ("%.2f" % s).to_s
  result += '0' if result.end_with?('.0')
  result
end

def cleaned(s)
  # guard against invalid byte sequence
  s = s.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
  s = s.encode('UTF-8', 'UTF-16')
end

def coloured(tf)
  red = 31
  green = 32
  colourize(tf ? green : red, tf)
end

def colourize(code, word)
  "\e[#{code}m#{word}\e[0m"
end

def get_test_log_stats
  test_log = `cat #{ARGV[0]}`
  test_log = cleaned(test_log)

  stats = {}

  warning_regex = /: warning:/m
  stats[:warning_count] = test_log.scan(warning_regex).size

  finished_pattern = "Finished in (#{number})s, (#{number}) runs/s"
  m = test_log.match(Regexp.new(finished_pattern))
  stats[:time]               = f2(m[1])
  stats[:tests_per_sec]      = m[2].to_i

  summary_pattern = %w(runs assertions failures errors skips).map{ |s| "(#{number}) #{s}" }.join(', ')
  m = test_log.match(Regexp.new(summary_pattern))
  stats[:test_count]      = m[1].to_i
  stats[:failure_count]   = m[3].to_i
  stats[:error_count]     = m[4].to_i
  stats[:skip_count]      = m[5].to_i

  stats
end

def percent(stats)
  raw = stats["lines"]["covered"].to_f / stats["lines"]["total"].to_f
  f2(raw * 100)
end

# - - - - - - - - - - - - - - - - - - - - - - -

log_stats = get_test_log_stats
test_stats = coverage_json['groups']['test']
src_stats = coverage_json['groups']['src']

# - - - - - - - - - - - - - - - - - - - - - - -

test_count    = log_stats[:test_count]
failure_count = log_stats[:failure_count]
error_count   = log_stats[:error_count]
warning_count = log_stats[:warning_count]
skip_count    = log_stats[:skip_count]
test_duration = log_stats[:time].to_f

src_coverage  = percent(src_stats)
test_coverage = percent(test_stats)

line_ratio = f2(test_stats["lines"]["total"].to_f / src_stats["lines"]["total"].to_f)
# hits_ratio = (src_stats[:hits_per_line].to_f / test_stats[:hits_per_line].to_f)

# - - - - - - - - - - - - - - - - - - - - - - -
# It is useful to keep these tolerances quite close
# to their limit. It helps to show large jumps which
# can be a sign of too much work in progres.

table =
  [
    [ 'tests',                  test_count,    '!=',   0 ],
    [ 'failures',               failure_count, '==',   0 ],
    [ 'errors',                 error_count,   '==',   0 ],
    [ 'warnings',               warning_count, '==',   0 ],
    [ 'skips',                  skip_count,    '==',   0 ],
    [ 'duration(test)[s]',      test_duration, '<=',   1 ],
    # Lower than the languages suite: names_from's construct-from-pairs
    # branch is languages-only (exercise start-points have no language/
    # test_framework pairs) so this suite cannot exercise it.
    [ 'coverage(src)[%]',       src_coverage,  '>=',  96 ],
    [ 'coverage(test)[%]',      test_coverage, '>=', 100 ],
    # Lowered (1.5): the shared starter.rb grew with languages-only methods
    # this suite cannot add matching tests for, and the hex-id refactor
    # removed the per-class hex_prefix method, both lowering the
    # test-to-source line ratio.
    [ 'lines(test)/lines(src)', line_ratio,    '>=', 1.5 ],
    # [ 'hits(src)/hits(test)',   hits_ratio,    '>=',   2 ],
  ]

# - - - - - - - - - - - - - - - - - - - - - - -

done = []
puts
table.each do |name,value,op,limit|
  result = eval("#{value} #{op} #{limit}")
  puts "%s | %s %s %s | %s" % [
    name.rjust(25), value.to_s.rjust(7), op, limit.to_s.rjust(5), coloured(result)
  ]
  done << result
end
puts
exit done.all?
