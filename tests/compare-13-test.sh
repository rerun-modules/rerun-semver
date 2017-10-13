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
describe "compare-rc-greater-than-rc"

#
# comparison type: greater than -- rc versions
#

# ------------------------------
# X.X.X-(A) > X.X.X-(B)
# ------------------------------
it_ret0_when_rc_ver_gt_rc_ver_special() {
  rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_TWO" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# X.X.(Y)-A > X.X.(Z)-B
# ------------------------------
it_ret0_when_rc_ver_gt_rc_ver_patch() {
  rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_EIGHT_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# X.(Y).X-A > X.(Z).X-B
# ------------------------------
it_ret0_when_rc_ver_gt_rc_ver_minor() {
  rerun semver: compare \
    --left_version "$RC_VERSION_TWO_SIX_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# (Y).X.X-A > (Z).X.X-B
# ------------------------------
it_ret0_when_rc_ver_gt_rc_ver_major() {
  rerun semver: compare \
    --left_version "$RC_VERSION_EIGHT_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# X.X.X-(A) !> X.X.X-(B)
# ------------------------------
it_ret1_when_rc_ver_notgt_rc_ver_special() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_TWO") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.(Y)-A !> X.X.(Z)-B
# ------------------------------
it_ret1_when_rc_ver_notgt_rc_ver_patch() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_EIGHT_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.(Y).X-A !> X.(Z).X-B
# ------------------------------
it_ret1_when_rc_ver_notgt_rc_ver_minor() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_SIX_SIX_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# (Y).X.X-A !> (Z).X.X-B
# ------------------------------
it_ret1_when_rc_ver_notgt_rc_ver_major() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RC_VERSION_EIGHT_FOUR_SIX_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}
