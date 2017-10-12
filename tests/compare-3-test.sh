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

# The Plan
# --------
describe "compare-rc-equals-rc"

#
# comparison type: equals -- special versions
#

# ------------------------------
# X.X.X-A == X.X.X-A
# ------------------------------
it_ret0_when_rc_ver_eq_rc_ver() {
  rerun semver: compare \
    --left_version "$SPECIAL_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "eq" \
    --right_version "$SPECIAL_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# X.X.X-(A) != X.X.X-(B)
# ------------------------------
it_ret1_when_rc_ver_noteq_rc_ver_special() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$SPECIAL_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "eq" \
    --right_version "$SPECIAL_VERSION_TWO_FOUR_SIX_RC_TEN") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.(Y)-A != X.X.(Z)-A
# ------------------------------
it_ret1_when_rc_ver_noteq_rc_ver_patch() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$SPECIAL_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "eq" \
    --right_version "$SPECIAL_VERSION_TWO_FOUR_EIGHT_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.(Y).X-A != X.(Z).X-A
# ------------------------------
it_ret1_when_rc_ver_noteq_rc_ver_minor() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$SPECIAL_VERSION_TWO_FIVE_FOUR_RC_ONE" \
    --compare "eq" \
    --right_version "$SPECIAL_VERSION_TWO_EIGHT_FOUR_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# (Y).X.X-A != (Z).X.X-A
# ------------------------------
it_ret1_when_rc_ver_noteq_rc_ver_major() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$SPECIAL_VERSION_TWO_FIVE_FOUR_RC_ONE" \
    --compare "eq" \
    --right_version "$SPECIAL_VERSION_TWO_EIGHT_FOUR_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}
