#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_custom_option_requires_image_name()
{
  build_start_points_image --custom

  local -r expected=(
    'ERROR: --custom requires preceding <image_name>'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 4
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_exercises_option_requires_image_name()
{
  build_start_points_image --exercises

  local -r expected=(
    'ERROR: --exercises requires preceding <image_name>'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 5
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_languages_option_requires_image_name()
{
  build_start_points_image --languages

  local -r expected=(
    'ERROR: --languages requires preceding <image_name>'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 6
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_git_repo_url_requires_preceding_custom_or_exercises_or_languages()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r git_repo_url=file://a/b/c

  build_start_points_image "${image_name}" "${git_repo_url}"

  refute_image_created "${image_name}"
  local -r expected=(
    "ERROR: <image-name> must be followed by one of --custom/--exercises/--languages"
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 7
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_custom_option_requires_at_least_one_following_git_repo_url()
{
  local -r image_name="${FUNCNAME[0]}"

  build_start_points_image "${image_name}" --custom

  refute_image_created "${image_name}"
  local -r expected=(
    'ERROR: --custom requires at least one <git-repo-url>'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 8
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_exercises_option_requires_at_least_one_following_git_repo_url()
{
  local -r image_name="${FUNCNAME[0]}"

  build_start_points_image "${image_name}" --exercises

  refute_image_created "${image_name}"
  local -r expected=(
    'ERROR: --exercises requires at least one <git-repo-url>'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 9
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_languages_option_requires_at_least_one_following_git_repo_url()
{
  local -r image_name="${FUNCNAME[0]}"

  build_start_points_image "${image_name}" --languages

  refute_image_created "${image_name}"
  local -r expected=(
    'ERROR: --languages requires at least one <git-repo-url>'
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 10
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_duplicate_custom_urls()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r url='https://github.com/cyber-dojo/start-points-custom.git'

  build_start_points_image "${image_name}" --custom "${url}" "${url}"

  refute_image_created "${image_name}"
  local -r expected=(
    'ERROR: --custom duplicated git-repo-urls'
    "${url}"
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 11
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_duplicate_exercise_urls()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r url='https://github.com/cyber-dojo/start-points-exercises.git'

  build_start_points_image "${image_name}" --exercises "${url}" "${url}"

  refute_image_created "${image_name}"
  local -r expected=(
    'ERROR: --exercises duplicated git-repo-urls'
    "${url}"
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 12
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_duplicate_language_urls()
{
  local -r image_name="${FUNCNAME[0]}"
  local -r url='https://github.com/cyber-dojo-languages/ruby-minitest'

  build_start_points_image "${image_name}" --languages "${url}" "${url}"

  refute_image_created "${image_name}"
  local -r expected=(
    'ERROR: --languages duplicated git-repo-urls'
    "${url}"
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 13
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test_malformed_image_name()
{
  local -r image_name='ALPHA/name' # no upper-case
  local -r url='https://github.com/cyber-dojo-languages/ruby-minitest'

  build_start_points_image "${image_name}" --languages "${url}"
  local -r expected=(
    "ERROR: malformed <image-name> ${image_name}"
  )
  assert_diagnostic_is "${expected[@]}"
  assert_status_equals 14
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo "::${0##*/}"
readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
. ${my_dir}/starter_helpers.sh
. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
