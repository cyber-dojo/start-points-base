
assert_diagnostic_is()
{
  # Do NOT check for exact match - in CI workflow, stderr/stdout are often interleaved
  # and you will get extra output if the CYBER_DOJO_DEBUG env-var is set to true
  local -r stderr="$(de_warned_cat "${stderrF}")"
  local expected_diagnostic=("$@")
  local missing_diagnostic=false

  for expected_line in "${expected_diagnostic[@]}"
  do
    if [[ "${stderr}" != *"${expected_line}"* ]]; then
      missing_diagnostic=true
      fail "expected stderr to include '${expected_line}'"
    fi
  done

  if [ "${missing_diagnostic}" == 'true' ]; then
    dump_stderr
    dump_stdout
    dump_status
    exit 42
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
  dump_status
  dump_stderr
  dump_stdout
}

dump_stdout()
{
  echo
  echo '<stdout>'
  de_warned_cat "${stdoutF}"
  echo '</stdout>'
}

dump_stderr()
{
  echo
  echo '<stderr>'
  de_warned_cat "${stderrF}"
  echo '</stderr>'
}

dump_status()
{
  echo
  echo '<status>'
  de_warned_cat "${statusF}"
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