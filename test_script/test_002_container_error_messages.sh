readonly my_dir="$( cd "$( dirname "${0}" )" && pwd )"

. ${my_dir}/starter_helpers.sh

X_test_002a_xxxxx()
{
  local image_name=cyberdojo/dummy
  #build_start_points_image ${image_name} --custom
  #assert_stdout_equals ''
  #assert_stderr_equals 'ERROR: --custom requires at least one <git-repo-url>'
  #assert_status_equals 9
  #refute_image_created "${image_name}"
}

. ${my_dir}/shunit2_helpers.sh
. ${my_dir}/shunit2
