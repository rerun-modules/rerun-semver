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
RC_VERSION_TWO_FOUR_RC_ONE="2.4-rc1"

# The Plan
# --------
describe "compare-invalid-rcs"

#
# comparison type: equals -- invalid rc versions
#

# ------------------------------
# X.X-Z == X.X-Z ?
# ------------------------------
it_ret3_when_both_rc_ver_invalid_w_eq() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_RC_ONE" \
    --compare "eq" \
    --right_version "$RC_VERSION_TWO_FOUR_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X-Z < X.X-Z ?
# ------------------------------
it_ret3_when_both_rc_ver_invalid_w_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_RC_ONE" \
    --compare "lt" \
    --right_version "$RC_VERSION_TWO_FOUR_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X-Z > X.X-Z ?
# ------------------------------
it_ret3_when_both_rc_ver_invalid_w_gt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X-Z == X.X.X-Z ?
# ------------------------------
it_ret3_when_left_rc_ver_invalid_w_eq() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_RC_ONE" \
    --compare "eq" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X-Z < X.X.X-Z ?
# ------------------------------
it_ret3_when_left_rc_ver_invalid_w_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_RC_ONE" \
    --compare "lt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X-Z > X.X.X-Z ?
# ------------------------------
it_ret3_when_left_rc_ver_invalid_w_gt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X-Z == X.X-Z ?
# ------------------------------
it_ret3_when_right_rc_ver_invalid_w_eq() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "eq" \
    --right_version "$RC_VERSION_TWO_FOUR_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X-Z < X.X-Z ?
# ------------------------------
it_ret3_when_right_rc_ver_invalid_w_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "lt" \
    --right_version "$RC_VERSION_TWO_FOUR_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X-Z > X.X-Z ?
# ------------------------------
it_ret3_when_right_rc_ver_invalid_w_gt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}
