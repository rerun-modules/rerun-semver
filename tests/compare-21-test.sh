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
describe "compare-rc-pess-minor-rc"

#
# comparison type: pess minor -- rc versions
#

# ------------------------------
# X.X.X-Z ~> X.X.X-Z ?
# ------------------------------
it_ret0_when_rc_ver_eq_rc_ver() {
  rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "pess_minor" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# X.X.X-(1) ~> X.X.X-(2) ?
# ------------------------------
it_ret1_when_rc_special_ver_lt_rc_special_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "pess_minor" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_TWO") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X-(2) ~> X.X.X-(1) ?
# ------------------------------
it_ret0_when_rc_special_ver_gt_rc_special_ver() {
  rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_TWO" \
    --compare "pess_minor" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# X.X.(1)-Z ~> X.X.(2)-Z ?
# ------------------------------
it_ret1_when_rc_patch_ver_lt_rc_patch_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "pess_minor" \
    --right_version "$RC_VERSION_TWO_FOUR_EIGHT_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.(2)-Z ~> X.X.(1)-Z ?
# ------------------------------
it_ret0_when_rc_patch_ver_gt_rc_patch_ver() {
  rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_EIGHT_RC_ONE" \
    --compare "pess_minor" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# X.(1).X-Z ~> X.(2).X-Z ?
# ------------------------------
it_ret1_when_rc_minor_ver_lt_rc_minor_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "pess_minor" \
    --right_version "$RC_VERSION_TWO_SIX_SIX_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.(2).X-Z ~> X.(1).X-Z ?
# ------------------------------
it_ret0_when_rc_minor_ver_gt_rc_minor_ver() {
  rerun semver: compare \
    --left_version "$RC_VERSION_TWO_SIX_SIX_RC_ONE" \
    --compare "pess_minor" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# (1).X.X-Z ~> (2).X.X-Z ?
# ------------------------------
it_ret1_when_rc_major_ver_lt_rc_major_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "pess_minor" \
    --right_version "$RC_VERSION_EIGHT_FOUR_SIX_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# (2).X.X-Z ~> (1).X.X-Z ?
# ------------------------------
it_ret1_when_rc_major_ver_gt_rc_major_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_EIGHT_FOUR_SIX_RC_ONE" \
    --compare "pess_minor" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}
