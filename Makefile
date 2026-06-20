
image:
	@${PWD}/bin/build_image.sh

test_image:
	@${PWD}/bin/test_image.sh

test_one:
	@${PWD}/bin/run_one_script_test.sh $(TEST)
