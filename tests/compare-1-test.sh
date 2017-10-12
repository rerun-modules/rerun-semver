#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m semver -p compare [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

rerun() {
  command $RERUN -M $RERUN_MODULES "$@"
}

# Constants

INVALID_COMPARISON_TYPE="invalidtestvalue"
INVALID_COMPARISON_TYPE_ERROR="comparison type is unsupported: $INVALID_COMPARISON_TYPE"

# The Plan
# --------
describe "compare-invalid-type"

#
# comparison type: invalid
#

# ------------------------------
# X.X.X ?? X.X.X
# ------------------------------
it_errors_when_comparison_type_invalid() {
  error_output=$(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "$INVALID_COMPARISON_TYPE" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX" 2>&1) && {
    echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$error_output" | grep -F "$INVALID_COMPARISON_TYPE"
}
