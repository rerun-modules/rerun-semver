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

# invalid semver
RELEASE_VERSION_THREE_SEVEN="3.7"

# The Plan
# --------
describe "compare-invalid-releases"

#
# comparison type: equals -- invalid release versions
#

# ------------------------------
# X.X != X.X.X
# ------------------------------
it_ret3_when_left_rel_ver_invalid_equals() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_THREE_SEVEN" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X != X.X
# ------------------------------
it_ret3_when_right_rel_ver_invalid_equals() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_THREE_SEVEN") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X !< X.X.X
# ------------------------------
it_ret3_when_left_rel_ver_invalid_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_THREE_SEVEN" \
    --compare "lt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X !< X.X
# ------------------------------
it_ret3_when_right_rel_ver_invalid_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "lt" \
    --right_version "$RELEASE_VERSION_THREE_SEVEN") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}
