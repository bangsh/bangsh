function b.test.task_test () {
  b.set 'bang.working_dir' 'fixtures'
  local output="$( (
    unset -f b.test.task_test
    btask.test.run --no-colors
  ) )"

  echo -e "$output" | grep -q '^F\.$'
  local has_test_progress_bar=$?
  b.unittest.assert_success $has_test_progress_bar

  echo "$output" | grep -q 'Check the following error messages'
  local has_error_output=$?
  b.unittest.assert_success $has_error_output

  echo "$output" | grep -q "Expected 'a', but got 'b' instead"
  local outputs_expectation=$?
  b.unittest.assert_success $outputs_expectation

  b.unset 'bang.working_dir'
}
