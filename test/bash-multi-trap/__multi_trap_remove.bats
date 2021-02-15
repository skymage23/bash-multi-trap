
@test 'test_callback_remove_empty_map' {
    source ../../bash-multi-trap.sh
    __multi_trap_remove '
}

@test 'test_callback_remove_not_exist' {
    source ../../bash-multi-trap.sh
    __multi_trap_add 'hello' 'goodbye'
    __multi_trap_remove 'hello'
    assert [ $? -eq 0 ]
}

@test 'test_callback_remove' {
   ..
}
