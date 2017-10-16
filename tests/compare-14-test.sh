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
describe "compare-release-greater-than-rc"

#
# comparison type: greater than -- left release version, right rc version
#

# ------------------------------
# X.X.X > X.X.X-Z ?
# ------------------------------
it_ret0_when_rel_ver_gt_rc_ver() {
  rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# X.X.(1) > X.X.(2)-Z ?
# ------------------------------
it_ret1_when_rel_patch_ver_lt_rc_patch_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
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
# X.X.(2) > X.X.(1)-Z ?
# ------------------------------
it_ret0_when_rel_patch_ver_gt_rc_patch_ver() {
  rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_EIGHT" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# X.(1).X > X.(2).X-Z ?
# ------------------------------
it_ret1_when_rel_minor_ver_lt_rc_minor_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
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
# X.(2).X > X.(1).X-Z ?
# ------------------------------
it_ret0_when_rel_minor_ver_gt_rc_minor_ver() {
  rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_SIX_SIX" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}

# ------------------------------
# (1).X.X > (2).X.X-Z ?
# ------------------------------
it_ret1_when_rel_major_ver_lt_rc_major_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "gt" \
    --right_version "$RC_VERSION_EIGHT_FOUR_SIX_RC_ONE") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# (2).X.X > (1).X.X-Z ?
# ------------------------------
it_ret0_when_rel_major_ver_gt_rc_major_ver() {
  rerun semver: compare \
    --left_version "$RELEASE_VERSION_EIGHT_FOUR_SIX" \
    --compare "gt" \
    --right_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE"
}
