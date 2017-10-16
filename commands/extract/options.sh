# Generated by stubbs:add-option. Do not edit, if using stubbs.
# Created: Mon Oct 16 13:35:55 CDT 2017
#
#/ usage: semver:extract  --input_version <>  --segment <> 

# _rerun_options_parse_ - Parse the command arguments and set option variables.
#
#     rerun_options_parse "$@"
#
# Arguments:
#
# * the command options and their arguments
#
# Notes:
#
# * Sets shell variables for any parsed options.
# * The "-?" help argument prints command usage and will exit 2.
# * Return 0 for successful option parse.
#
rerun_options_parse() {
  
    unrecognized_args=()

    while (( "$#" > 0 ))
    do
        OPT="$1"
        case "$OPT" in
            --input_version) rerun_option_check $# $1; INPUT_VERSION=$2 ; shift 2 ;;
            --segment) rerun_option_check $# $1; SEGMENT=$2 ; shift 2 ;;
            # help option
            -\?|--help)
                rerun_option_usage
                exit 2
                ;;
            # unrecognized arguments
            *)
              unrecognized_args+=("$OPT")
              shift
              ;;
        esac
    done

    # Set defaultable options.

    # Check required options are set
    [[ -z "$INPUT_VERSION" ]] && { echo >&2 "missing required option: --input_version" ; return 2 ; }
    [[ -z "$SEGMENT" ]] && { echo >&2 "missing required option: --segment" ; return 2 ; }
    # If option variables are declared exportable, export them.

    # Make unrecognized command line options available in $_CMD_LINE
    if [ ${#unrecognized_args[@]} -gt 0 ]; then
      export _CMD_LINE="${unrecognized_args[@]}"
    fi
    #
    return 0
}


# If not already set, initialize the options variables to null.
: ${INPUT_VERSION:=}
: ${SEGMENT:=}
# Default command line to null if not set
: ${_CMD_LINE:=}


