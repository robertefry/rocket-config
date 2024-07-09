#!/bin/bash

tools.editors.comments()
{(
    print_help()
    {
        printf "%s" "\
Comment and uncomment lines in-place in the file, <file-in>, matching a regex pattern, <pattern>.

Use: tools.editors.comments <file-in> [arguments] [flags] [patterns]

    -h  --help          print this help page, and exit

[arguments]:
    -t  --token         the regex pattern representing the start of a single-line comment               ('#' by default)
    -d  --delim         the single-character regex delimiter (must not be in a <pattern> or <token>)    ('/' by default)
    -s  --spacer        the space string to use between comment tokens and content                      (''  by default)

[flags]:
    -i  --ignore-case   use case-insensitive regex patterns                                             (off by default)
    -v  --verbose       print each line being changed                                                   (off by default)

[patterns]:
    -c <pattern>        comment all lines matching the <pattern>
    -C <pattern>        comment the first line matching the <pattern>
    -u <pattern>        uncomment all lines matching the <pattern>
    -U <pattern>        uncomment the first line matching the <pattern>
"
    }

    local _arg_file=""

    local _arg_ignore_case="off"
    local _arg_verbose="off"

    local _arg_token="#"
    local _arg_delim="/"
    local _arg_spacer=""

    local _arg_comment_all=()
    local _arg_comment_first=()
    local _arg_uncomment_all=()
    local _arg_uncomment_first=()

    parse_commandline()
    {
        local _positionals=()
        local _positionals_count=0

        die()
        {
            local _ret="${2:-1}"
            test "${_PRINT_HELP:-no}" = yes && print_help >&2
            printf "\e[31;40mERROR: %s\n" "$1" >&2
            exit "${_ret}"
        }
        begins_with_short_option()
        {
            local first_option all_short_options='otdivcCuUh'
            first_option="${1:0:1}"
            test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
        }

        while test $# -gt 0
        do
            local _key="$1"
            case "$_key" in
            ### arguments
                -t|--token)
                    test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                    _arg_token="$2"
                    shift
                    ;;
                --token=*)
                    _arg_token="${_key##--token=}"
                    ;;
                -t*)
                    _arg_token="${_key##-t}"
                    ;;
                -d|--delim)
                    test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                    _arg_delim="$2"
                    shift
                    ;;
                --delim=*)
                    _arg_delim="${_key##--delim=}"
                    ;;
                -d*)
                    _arg_delim="${_key##-d}"
                    ;;
                -s|--spacer)
                    test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                    _arg_spacer="$2"
                    shift
                    ;;
                --spacer=*)
                    _arg_spacer="${_key##--delim=}"
                    ;;
                -s*)
                    _arg_spacer="${_key##-d}"
                    ;;
            ### flags
                -i|--no-ignore-case|--ignore-case)
                    _arg_ignore_case="on"
                    test "${1:0:5}" = "--no-" && _arg_ignore_case="off"
                    ;;
                -i*)
                    _arg_ignore_case="on"
                    _next="${_key##-i}"
                    if test -n "$_next" -a "$_next" != "$_key"
                    then
                        { begins_with_short_option "$_next" && shift && set -- "-i" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                    fi
                    ;;
                -v|--no-verbose|--verbose)
                    _arg_verbose="on"
                    test "${1:0:5}" = "--no-" && _arg_verbose="off"
                    ;;
                -v*)
                    _arg_verbose="on"
                    _next="${_key##-v}"
                    if test -n "$_next" -a "$_next" != "$_key"
                    then
                        { begins_with_short_option "$_next" && shift && set -- "-v" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
                    fi
                    ;;
            ### patterns
                -c|--comment-all)
                    test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                    _arg_comment_all+=("$2")
                    shift
                    ;;
                --comment-all=*)
                    _arg_comment_all+=("${_key##--comment-all=}")
                    ;;
                -c*)
                    _arg_comment_all+=("${_key##-c}")
                    ;;
                -C|--comment-first)
                    test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                    _arg_comment_first+=("$2")
                    shift
                    ;;
                --comment-first=*)
                    _arg_comment_first+=("${_key##--comment-first=}")
                    ;;
                -C*)
                    _arg_comment_first+=("${_key##-C}")
                    ;;
                -u|--uncomment-all)
                    test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                    _arg_uncomment_all+=("$2")
                    shift
                    ;;
                --uncomment-all=*)
                    _arg_uncomment_all+=("${_key##--uncomment-all=}")
                    ;;
                -u*)
                    _arg_uncomment_all+=("${_key##-u}")
                    ;;
                -U|--Uncomment-first)
                    test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
                    _arg_uncomment_first+=("$2")
                    shift
                    ;;
                --Uncomment-first=*)
                    _arg_uncomment_first+=("${_key##--Uncomment-first=}")
                    ;;
                -U*)
                    _arg_uncomment_first+=("${_key##-U}")
                    ;;
            ### other
                -h|--help)
                    print_help
                    exit 0
                    ;;
                -h*)
                    print_help
                    exit 0
                    ;;
                *)
                    _last_positional="$1"
                    _positionals+=("$_last_positional")
                    _positionals_count=$((_positionals_count + 1))
                    ;;
            esac
            shift
        done

        handle_passed_args_count()
        {
            local _required_args_string="'file-in'"
            test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "Not enough positional arguments - we require exactly 1 (namely: $_required_args_string), but got only ${_positionals_count}." 1
            test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "There were spurious positional arguments --- we expect exactly 1 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
        }
        handle_passed_args_count

        assign_positional_args()
        {
            local _positional_name _shift_for=$1
            _positional_names="_arg_file "

            shift "$_shift_for"
            for _positional_name in ${_positional_names}
            do
                test $# -gt 0 || break
                eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
                shift
            done
        }
        assign_positional_args 1 "${_positionals[@]}"

        validate_args()
        {
            # '_arg_delim' must be a single character
            test "${#_arg_delim}" -eq 1 || die "Invalid delimiter (specified with -d) - we require the delimiter to be a single character, but we got ${#_arg_delim} characters."
        }
        validate_args
    }
    parse_commandline "$@"

    # what flags does sed use
    local _sed_flags=""
    test "$_arg_ignore_case" = "on" && _sed_flags="${_sed_flags}I"
    test "$_arg_verbose"     = "on" && _sed_flags="${_sed_flags}p"

    _sed_replace()
    {
        local flg="$1"
        local ptn="$2"
        local src="$3"
        local dst="$4"
        local dlm="$_arg_delim"

        local _sed_script="${dlm}${ptn}${dlm}s${dlm}${src}${dlm}${dst}${dlm}${flg}"
        sed -i "$_arg_file" -e "$_sed_script"
    }

    local pattern=""
    for pattern in "${_arg_comment_all[@]}"
    do
        _sed_replace "${_sed_flags}g" "^[^(${_arg_token})]*${pattern}" "^" "${_arg_token}${_arg_spacer}"
    done
    for pattern in "${_arg_comment_first[@]}"
    do
        _sed_replace "${_sed_flags}" "^[^(${_arg_token})]*${pattern}" "^" "${_arg_token}${_arg_spacer}"
    done
    for pattern in "${_arg_uncomment_all[@]}"
    do
        _sed_replace "${_sed_flags}g" "${pattern}" "^${_arg_token}\s*" ""
    done
    for pattern in "${_arg_uncomment_first[@]}"
    do
        _sed_replace "${_sed_flags}" "${pattern}" "^${_arg_token}\s*" ""
    done
)}
