The test_data/ dir contains a Dockerfile used to
create an image whose service is to create named
data-sets for use in test_script/
The named data-sets can be clean data-sets
which will be copies of the custom/exercises/languages
dir. They can also be fabricated data-sets which
are created by make_data_set.rb by making a copy
of a clean data-set and then inserting one specific error.
