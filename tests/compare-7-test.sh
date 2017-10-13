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
RC_VERSION_SIX_TWO_ALPHA_FOUR="6.2-alpha4"

# The Plan
# --------
describe "compare-invalid-rcs"

#
# comparison type: equals -- invalid rc versions
#

# ------------------------------
# X.X-A != X.X.X
# ------------------------------
it_ret3_when_left_rc_ver_invalid_equals() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_SIX_TWO_ALPHA_FOUR" \
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
# X.X.X != X.X-A
# ------------------------------
it_ret3_when_right_rc_ver_invalid_equals() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "eq" \
    --right_version "$RC_VERSION_SIX_TWO_ALPHA_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X-A !< X.X.X
# ------------------------------
it_ret3_when_left_rc_ver_invalid_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_SIX_TWO_ALPHA_FOUR" \
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
# X.X.X !< X.X-A
# ------------------------------
it_ret3_when_right_rc_ver_invalid_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "lt" \
    --right_version "$RC_VERSION_SIX_TWO_ALPHA_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X-A !> X.X.X
# ------------------------------
it_ret3_when_left_rc_ver_invalid_gt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_SIX_TWO_ALPHA_FOUR" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X !> X.X-A
# ------------------------------
it_ret3_when_right_rc_ver_invalid_gt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "gt" \
    --right_version "$RC_VERSION_SIX_TWO_ALPHA_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}
