readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

. ${my_dir}/starter_helpers.sh

create_git_repo_from_named_data_set()
{
  local tmp_dir="${1}"
  local data_set_name="${2}"
  docker run \
    --user root \
    --rm \
    --volume "${tmp_dir}/${data_set_name}:/app/tmp/${data_set_name}:rw" \
    cyberdojo/create-start-points-test-data \
      "${data_set_name}" \
      "/app/tmp/${data_set_name}"
}

test_003a_simple_success_case()
{
  local image_name="${FUNCNAME[0]}"
  local tmp_dir=$(mktemp -d "${my_dir}/../tmp/cyber-dojo-start-points-base.XXX")

  create_git_repo_from_named_data_set "${tmp_dir}" good_custom
  create_git_repo_from_named_data_set "${tmp_dir}" good_exercises
  create_git_repo_from_named_data_set "${tmp_dir}" good_languages

  build_start_points_image \
    "${image_name}"  \
      --custom    "file://${tmp_dir}/good_custom"    \
      --exercises "file://${tmp_dir}/good_exercises" \
      --languages "file://${tmp_dir}/good_languages"

  # TODO: delete tmp_dir

  #assert_stdout_equals ''
  #--custom 	 /Users/jonjagger/repos/cyber-dojo/start-points-base/test_script/../tmp/cyber-dojo-start-points-base.A0y/good_custom
  #--exercises 	 /Users/jonjagger/repos/cyber-dojo/start-points-base/test_script/../tmp/cyber-dojo-start-points-base.A0y/good_exercises
  #--languages 	 /Users/jonjagger/repos/cyber-dojo/start-points-base/test_script/../tmp/cyber-dojo-start-points-base.A0y/good_languages

  assert_stderr_equals ''
  assert_status_equals 0
  assert_image_created "${image_name}"
  docker image rm "${image_name}" > /dev/null
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
