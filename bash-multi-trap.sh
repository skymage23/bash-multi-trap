#!/bin/bash
if [ "$__MULTI_TRAP_MAP" == "" ]; then
    __MULTI_TRAP_MAP="defined"
    source bash-multi-trap-constants.sh

    __multi_trap_map=""
    __multi_trap_counter=0
    
    function __multi_trap_add(){
        local __name=$1
        local __value=$2
        if [ $__multi_trap_counter -gt -0 ]; then 
             __multi_trap_map="$__multi_trap_map:$__name/$__value"
	else
             __multi_trap_map="$__name/$__value"
	fi
	__multi_trap_counter=$((__multi_trap_counter + 1))
    }
    
    
    #Dumb search.  Switch to hash table if curr map too big:
    function __multi_trap_remove(){
        __trap_err_clear_errcode
        if [ '$__multi_trap_map' == ""]; then
            return 0
        fi
    
        local __target=$1
        local __new_map=''
        local __cont_or_not=0
        local __name=''
        local __value=''
    
        local __ifs_curr="$IFS"
        local __ifs_prev=''
        local __first=1
        IFS="$__multi_trap_map_rec_separator"
        for var in $__multi_trap_map; do
            {   
    	    __ifs_prev="$IFS"
    	    IFS="$__multi_trap_map_field_separator"
                read __name __value
    	    if [ "$__name" == "$__target" ]; then
                    __cont_or_not=1
    	    fi
    	    IFS="$__ifs_prev"
    	} <<< "$var"
            if [ $__cont_or_not -eq 1 ]; then
    	    __cont_or_not=0
                continue;
            fi
    	if [ $__first -eq 0 ]; then
    	    __new_map="$__new_map:$var"
            else
                __new_map="$var"
    	    __first=0
            fi
        done
        IFS="$__ifs_curr"
        __multi_trap_map="$__new_map"
	__multi_trap_counter=$((__multi_trap_counter - 1))
    }
    
    function __multi_trap_run(){
        if [ "$__multi_trap_map" == "" ]; then
            return 0
        fi
        local __init_ifs=':'
        local __name=''
        local __value=''
        local __ifs_prev=''
        local __ifs_curr="$IFS"
        IFS=':'
        for var in $__multi_trap_map; do
            {
    	    __ifs_prev=$IFS
    	    IFS='/'
    	    {
                    read __name __value
    		$__value
                } <<< $var
                IFS=$__ifs_prev
            }
        done
        IFS="$__ifs_curr"
    }
fi
