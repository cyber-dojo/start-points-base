
assert_diagnostic_is()
{
  # assert_stdout_equals ''
  local expected_diagnostic=("$@")
  for expected_line in "${expected_diagnostic[@]}"
  do
     assert_diagnostic_includes "${expected_line}"
  done
  # local -r stdout="$(de_warned_cat "${stdoutF}")"
  # local -r length=$(echo "${stdout}" | wc -l | awk '{ print $1 }')
  # assert_equal ${#expected[@]} "${length}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_diagnostic_includes()
{
  local -r includes="${1}"
  local -r stdout="$(de_warned_cat "${stdoutF}")"
  local -r stderr="$(de_warned_cat "${stderrF}")"
  local output="${stdout}${stderr}"
  if [[ "${output}" != *"${includes}"* ]]; then
    printf "<stdout>\n%s\n</stdout>\n" "${stdout}"
    printf "<stderr>\n%s\n</stderr>\n" "${stderr}"
    fail "expected output to include ${includes}"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_stdout_empty()
{
  assert_stdout_equals ''
}

assert_stdout_equals()
{
  local -r message="stdout:$(dump_sss)"
  local -r expected="${1}"
  local -r actual="$(de_warned_cat "${stdoutF}")"
  assertEquals "${message}" "${expected}" "${actual}"

}

assert_stdout_includes()
{
  local -r includes="${1}"
  local -r stdout="$(de_warned_cat "${stdoutF}")"
  if [[ "${stdout}" != *"${includes}"* ]]; then
    echo "<stdout>"
    echo "${stdout}"
    echo "</stdout>"
    fail "expected stdout to include ${includes}"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_stderr_empty()
{
  assert_stderr_equals ''
}

assert_stderr_equals()
{
  local -r message="stderr:$(dump_sss)"
  local -r expected="${1}"
  local -r actual="$(de_warned_cat "${stderrF}")"
  assertEquals "${message}" "${expected}" "${actual}"
}

assert_stderr_includes()
{
  local -r includes="${1}"
  local -r stderr="$(de_warned_cat "${stderrF}")"
  if [[ "${stderr}" != *"${includes}"* ]]; then
    echo "<stderr>"
    echo "${stderr}"
    echo "</stderr>"
    fail "expected stderr to include ${includes}"
  fi
}

assert_stderr_line_count_equals()
{
  # local -r newline=$'\n'
  local -r stderr="$(de_warned_cat "${stderrF}")"
  local -r diagnostic=$(printf 'stderr-line-count\n<stderr>\n%s\n</stderr>\n' "${stderr}")
  assertEquals "${diagnostic}" "${1}" "$(echo "${stderr}" | wc -l | awk '{ print $1 }')"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

assert_status_0()
{
  assert_status_equals 0
}

assert_status_equals()
{
  local -r message="status:$(dump_sss)"
  local -r expected="${1}"
  local -r actual="$(cat "${statusF}")"
  assertEquals "${message}" "${expected}" "${actual}"
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
  echo
  echo '<stdout>'
  cat "${stdoutF}"
  echo '</stdout>'
}

dump_stderr()
{
  echo
  echo '<stderr>'
  cat "${stderrF}"
  echo '</stderr>'
}

dump_status()
{
  echo
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
  cd "$(dirname "${1}")"
  printf "%s/%s\n" "$(pwd)" "$(basename "${1}")"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

de_warned_cat()
{
  local -r filename="${1}"
  local -r warning="WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested"
  cat "${filename}" | grep -v "${warning}"
}