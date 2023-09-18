
assert_stdout_equals()
{
  assertEquals 'stdout' "$1" "`de_warned_cat ${stdoutF}`"
}

assert_stdout_includes()
{
  local stdout="`de_warned_cat ${stdoutF}`"
  if [[ "${stdout}" != *"${1}"* ]]; then
    echo "<stdout>"
    echo "${stdout}"
    echo "</stdout>"
    fail "expected stdout to include ${1}"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_stderr_equals()
{
  assertEquals 'stderr' "$1" "`de_warned_cat ${stderrF}`"
}

assert_stderr_includes()
{
  local stderr="`de_warned_cat ${stderrF}`"
  if [[ "${stderr}" != *"${1}"* ]]; then
    echo "<stderr>"
    echo "${stderr}"
    echo "</stderr>"
    fail "expected stderr to include ${1}"
  fi
}

assert_stderr_line_count_equals()
{
  local newline=$'\n'
  local stderr="`de_warned_cat ${stderrF}`"
  local diagnostic=$(printf 'stderr-line-count\n<stderr>\n%s\n</stderr>\n' "${stderr}")
  assertEquals "${diagnostic}" ${1} $(echo "${stderr}" | wc -l | awk '{ print $1 }')
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_status_equals()
{
  assertEquals 'status' "$1" "`cat ${statusF}`"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dump_sss()
{
  dump_stdout
  dump_stderr
  dump_status
}

dump_stdout()
{
  echo '<stdout>'
  cat "${stdoutF}"
  echo '</stdout>'
}

dump_stderr()
{
  echo '<stderr>'
  cat "${stderrF}"
  echo '</stderr>'
}

dump_status()
{
  echo '<status>'
  cat "${statusF}"
  echo '</status>'
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

oneTimeSetUp()
{
  outputDir="${SHUNIT_TMPDIR}/output"
  mkdir "${outputDir}"
  stdoutF="${outputDir}/stdout"
  stderrF="${outputDir}/stderr"
  statusF="${outputDir}/status"
  testDir="${SHUNIT_TMPDIR}/some_test_dir"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

absPath()
{
  # use like this [ local resolved=`abspath ./../a/b/c` ]
  cd "$(dirname "$1")"
  printf "%s/%s\n" "$(pwd)" "$(basename "$1")"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

de_warned_cat()
{
  filename="${1}"
  warning="WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested"
  cat "${filename}" | grep -v "${warning}"
}