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
# X.X.(Y) > X.X.(X)-B
# ------------------------------
it_ret0_when_rel_ver_gt_rc_ver_patch() {
  rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_EIGHT_RC_ONE" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX"
}

# ------------------------------
# X.(Y).X > X.(X).X-B
# ------------------------------
it_ret0_when_rel_ver_gt_rc_ver_minor() {
  rerun semver: compare \
    --left_version "$RC_VERSION_TWO_SIX_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX"
}

# ------------------------------
# (Y).X.X > (Z).X.X-B
# ------------------------------
it_ret0_when_rel_ver_gt_rc_ver_major() {
  rerun semver: compare \
    --left_version "$RC_VERSION_EIGHT_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX"
}

# ------------------------------
# X.X.X !> X.X.X-(B)
# ------------------------------
it_ret1_when_rel_ver_notgt_rc_ver_special() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.(Y) !> X.X.(Z)-B
# ------------------------------
it_ret1_when_rel_ver_notgt_rc_ver_patch() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_EIGHT") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.(Y).X !> X.(Z).X-B
# ------------------------------
it_ret1_when_rel_ver_notgt_rc_ver_minor() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_SIX_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# (Y).X.X !> (Z).X.X-B
# ------------------------------
it_ret1_when_rel_ver_notgt_rc_ver_major() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RC_VERSION_TWO_FOUR_SIX_RC_ONE" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_EIGHT_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}