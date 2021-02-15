load ../libs/bats-support/load
load ../libs/bats-assert/load


function goodbye() {
    echo "goodbye";
}

function hello() {
    echo "hello"
}

@test 'test_callback_single_add' {
    source ../../bash-multi-trap.sh
    __multi_trap_add hello goodbye
    
    assert [ "$__multi_trap_map" == "hello/goodbye" ]
}

@test 'test_callback_multi_add' {
    source ../../bash-multi-trap.sh
    __multi_trap_add you_say goodbye
    __multi_trap_add I_say hello
    assert [ "$__multi_trap_map" == "you_say/goodbye:I_say/hello" ]
}
