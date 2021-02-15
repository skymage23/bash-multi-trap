load ../libs/bats-support/load
load ../libs/bats-assert/load

@test 'test_callback_errcode_blank_errcode' {
    TEST_MODE='defined'
    source ../../bash-multi-trap-errcodes.sh
    __trap_err_errcode=-1
    __trap_errcode_to_string
    assert [ $? -eq 0 ]
    assert [ "$__trap_err_message" == "No error. Placeholder. \"All is good\" errcode." ]
}

@test 'test_callback_errcode_no_exist' {
   run bash -c "\
           TEST_MODE='defined'; \
           source ../../bash-multi-trap-errcodes.sh; \
           __trap_err_errcode=10; \
           __trap_errcode_to_string; \
           stat=\$?; \
           echo \$__trap_err_message; \
           exit \$stat;
       "

   assert [ $status -eq 1 ]
   assert [ "$output" == "Unknown error" ]
}

@test 'test_callback_errcode_exists' {
    TEST_MODE='defined'
    source ../../bash-multi-trap-errcodes.sh
    __trap_err_errcode=0
    __trap_errcode_to_string
    assert [ "$__trap_err_message" == "__trap_err_remove_empty_map: There are no callbacks registered" ]
}
