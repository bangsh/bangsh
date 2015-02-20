function b.test.assert_raise () {
  function catch_it () { b.raise TestingException ; }
  b.unittest.assert_raise catch_it TestingException
}

function b.test.run_successfuly_returns_true_when_test_case_passes () {
  function a_success_case () {
    b.unittest.assert_equal 'a' 'a'
  }

  b.unittest.run_successfuly? a_success_case &>/dev/null
  b.unittest.assert_success $?
}

function b.test.run_successfuly_returns_false_when_test_case_fails () {
  function a_fail_case () {
    b.unittest.assert_equal 'a' 'b'
  }

  b.unittest.run_successfuly? a_fail_case &>/dev/null
  b.unittest.assert_error $?
}
