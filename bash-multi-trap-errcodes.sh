if [ "$BASH_MULTI_TRAP_ERRCODES" == '' ]; then
    BASH_MULTI_TRAP_ERRCODES="defined"
    
    if [ "${TEST_MODE}x" == 'x' ]; then
        source bash-multi-trap-constants.sh
    else
        source ../../bash-multi-trap-constants.sh
    fi
    
    #bash-multi-trap-errcodes-specific errors:
    __trap_err_no_err_msg="Unknown error" #Used when we don't recognize an errcode


    #"Blank" errcode. Used to reset "__trap_err_errcode".
    __trap_err_blank_errcode='-1'
    __trap_err_blank_errcode_msg="No error. Placeholder. \"All is good\" errcode."

    #bash_multi_trap.sh.__multi_trap_remove():
    __trap_err_remove_empty_map=0
    __trap_err_remove_no_exist=1
    
    #Errcode to String map:
    __trap_err_map="\
0:__trap_err_remove_empty_map:There are no callbacks registered./\
1:__trap_err_remove_no_exist:There are no callbacks of the specified name registered.\
"


    __trap_err_errcode=$__trap_err_blank_errcode
    
    function __trap_err_clear_errcode {
        __trap_err_errcode=$__trap_err_blank_errcode
    }

    __trap_err_message=''
    function __trap_errcode_to_string {
       local __errcode=$__trap_err_errcode
       local __curr_ifs="$IFS"
       local __prev_ifs="$IFS"
       local __retval=''
       local __code=-1
       local __name=''
       local __message=''
       local __quit=0

       #Has a valid error been recorded? If not, quietly return.
       if [ $__errcode -eq $__trap_err_blank_errcode ]; then
           __trap_err_message="$__trap_err_blank_errcode_msg"
	   return 0
       fi

       #Parse the errcode-to-string mapping and locate the correct string.
       {
           local var
           IFS="$__multi_trap_map_rec_divider"
           while read var; do
           {
       	       {
    	           __prev_ifs="$IFS"
    	           IFS="$__multi_trap_map_field_divider"
                   read __code __name __message
    	           if [ $__code -eq $__errcode ]; then
                       __retval="$__name: $__message"
    		       __quit=1
                   fi
		   IFS=$__prev_ifs
               } <<< $var
               if [ $__quit -eq 1 ]; then
                   break;
               fi
           }
           done
       } <<< $__trap_err_map
       IFS="$__curr_ifs"
       if [ $__quit -eq 0 ]; then
           __trap_err_message="$__trap_err_no_err_msg"
           return 1;
       fi
       __trap_err_message="$__retval"
    }
fi
