function b.unittest.teardown {
  b.opt.reset
}

function b.test.if_options_exists () {
  b.opt.add_opt --test "Testing this"
  b.unittest.assert_success $?

  b.opt.is_opt? --test
  b.unittest.assert_success $?

  local usage="$(b.opt.show_usage)"

  echo "$usage" | grep -q "\--test"
  b.unittest.assert_success $?

  echo "$usage" | grep -q "Testing this"
  b.unittest.assert_success $?
}

function b.test.if_flag_exists () {
  b.opt.add_flag --help "This is a flag."
  b.unittest.assert_success $?

  b.opt.is_flag? --help
  b.unittest.assert_success $?

  local usage="$(b.opt.show_usage)"

  echo "$usage" | grep -q "\--help"
  b.unittest.assert_success $?

  echo "$usage" | grep -q "This is a flag."
  b.unittest.assert_success $?
}

function b.test.option_and_flag_aliasing () {
  b.opt.add_flag --help "This is a flag"
  b.opt.add_opt --test "This is an option"

  b.opt.add_alias --help -h
  b.unittest.assert_success $?

  b.opt.add_alias "--test" "-t"
  b.unittest.assert_success $?

  b.unittest.assert_equal --help $(b.opt.alias2opt -h)
  b.unittest.assert_equal --test $(b.opt.alias2opt -t)
}

function b.test.multiple_alias_for_single_option () {
  b.opt.add_opt --foo "Foo"
  b.opt.add_alias --foo -b
  b.opt.add_alias --foo -a
  b.opt.add_alias --foo -r

  b.unittest.assert_equal "$(b.opt.alias2opt -b)" --foo
  b.unittest.assert_equal "$(b.opt.alias2opt -a)" --foo
  b.unittest.assert_equal "$(b.opt.alias2opt -r)" --foo
}

function b.test.required_arg_not_present () {
  b.opt.add_flag --foo "\--foo arg"
  b.opt.add_alias --foo -f
  b.opt.required_args --foo

  # No arguments called
  b.opt.init
  b.unittest.assert_raise b.opt.check_required_args RequiredOptionNotSet
}

function b.test.required_arg_called_with_long_args () {
  b.opt.add_flag --foo "\--foo arg"
  b.opt.add_alias --foo -f
  b.opt.required_args --foo

  ## Calling with long version!
  b.opt.init --foo
  b.opt.check_required_args 
  b.unittest.assert_success $?
}

function b.test.required_arg_called_with_short_args () {
  b.opt.add_flag --foo "\--foo arg"
  b.opt.add_alias --foo -f
  b.opt.required_args --foo

  ## Calling with short version!
  b.opt.init '-f'
  b.opt.check_required_args
  b.unittest.assert_success $?
}

function b.test.has_flag_set () {
  b.opt.add_flag --foo "foo"
  b.opt.init --foo
  b.opt.has_flag? --foo
  b.unittest.assert_success $?
}

function b.test.has_not_flag_set () {
  b.opt.add_flag --foo "foo"
  b.opt.init
  b.opt.has_flag? --foo
  b.unittest.assert_error $?
}

function b.test.get_opt () {
  b.opt.add_opt --foo "Foo is an option"
  b.opt.init --foo "bar"
  b.unittest.assert_equal "bar" $(b.opt.get_opt --foo)
}

function b.test.test_usage_output () {
  b.opt.add_opt --email "Set the email"
  b.opt.add_alias --email -e

  b.opt.show_usage | grep -q -e '--email|-e'
  b.unittest.assert_success $?
}

function b.test.test_multiple_options_and_aliases () {
  b.opt.add_flag --foo "foo"

  b.opt.add_opt --email "Specify text to be printed"
  b.opt.add_alias --email -e

  b.opt.add_opt --company "Specify text to be printed"
  b.opt.add_alias --company -cp

  b.opt.add_opt --customer "Specify text to be printed"
  b.opt.add_alias --customer -c

  b.opt.add_opt --index "Specify text to be printed"
  b.opt.add_alias --index -i

  b.opt.add_opt --port "Specify text to be printed"
  b.opt.add_alias --port -p

  b.opt.add_opt --grove "Specify text to be printed"
  b.opt.add_alias --grove -g

  b.opt.add_opt --password "Specify text to be printed"
  b.opt.add_alias --password -ps

  b.opt.add_opt --area "Specify text to be printed"
  b.opt.add_alias --area -a

  b.opt.add_opt --url "Specify text to be printed"
  b.opt.add_alias --url -u

  b.opt.add_opt --instance "Specify text to be printed"
  b.opt.add_alias --instance -is

  b.opt.init -c "groupbydemo" -cp "groupby" -i "congo" -a "Sample" -ps p@ssw0rd -e "benny@gmail.com" -g "001" \
      -is "us-serve1-f" -p "9200" -u "http://localhost" --foo

  b.unittest.assert_equal "groupby" "$(b.opt.get_opt --company)"
  b.unittest.assert_equal "groupbydemo" "$(b.opt.get_opt --customer)"
  b.unittest.assert_equal "congo" "$(b.opt.get_opt --index)"
  b.unittest.assert_equal "Sample" "$(b.opt.get_opt --area)"
  b.unittest.assert_equal "p@ssw0rd" "$(b.opt.get_opt --password)"
  b.unittest.assert_equal "benny@gmail.com" "$(b.opt.get_opt --email)"
  b.unittest.assert_equal "001" "$(b.opt.get_opt --grove)"
  b.unittest.assert_equal "us-serve1-f" "$(b.opt.get_opt --instance)"
  b.unittest.assert_equal "9200" "$(b.opt.get_opt --port)"
  b.unittest.assert_equal "http://localhost" "$(b.opt.get_opt --url)"

  b.opt.has_flag? --foo
  b.unittest.assert_success $?
}
