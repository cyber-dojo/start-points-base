readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"
readonly root_dir="$(cd "${my_dir}/.." && pwd)"

. ${my_dir}/starter_helpers.sh

test_003a_simple_success_case()
{
  local image_name="${FUNCNAME[0]}"
  local tmp_dir=$(mktemp -d "${root_dir}/tmp/cyber-dojo-start-points-base.XXX")

  create_git_repo_from_named_data_set "${tmp_dir}" good_custom
  create_git_repo_from_named_data_set "${tmp_dir}" good_exercises
  create_git_repo_from_named_data_set "${tmp_dir}" good_languages

  build_start_points_image \
    "${image_name}"  \
      --custom    "file://${tmp_dir}/good_custom"    \
      --exercises "file://${tmp_dir}/good_exercises" \
      --languages "file://${tmp_dir}/good_languages"

  # TODO: delete tmp_dir

  assert_stdout_includes $(echo -e "--custom \t file://${tmp_dir}/good_custom")
  assert_stdout_includes $(echo -e "--exercises \t file://${tmp_dir}/good_exercises")
  assert_stdout_includes $(echo -e "--languages \t file://${tmp_dir}/good_languages")
  #assert_stdout_line_count_equals 3

  assert_stderr_equals ''
  assert_status_equals 0
  assert_image_created "${image_name}"
  docker image rm "${image_name}" > /dev/null
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
