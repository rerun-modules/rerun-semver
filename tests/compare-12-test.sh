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
describe "compare-release-greater-than-release"

#
# comparison type: greater than -- release versions
#

# ------------------------------
# X.X.(Y) > X.X.(Z)
# ------------------------------
it_ret0_when_rel_ver_gt_rel_ver_patch() {
  rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_EIGHT" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX"
}

# ------------------------------
# X.(Y).X > X.(Z).X
# ------------------------------
it_ret0_when_rel_ver_gt_rel_ver_minor() {
  rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_SIX_SIX" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX"
}

# ------------------------------
# (Y).X.X > (Z).X.X
# ------------------------------
it_ret0_when_rel_ver_gt_rel_ver_major() {
  rerun semver: compare \
    --left_version "$RELEASE_VERSION_EIGHT_FOUR_SIX" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX"
}

# ------------------------------
# X.X.(Y) !> X.X.(Z)
# ------------------------------
it_ret1_when_rel_ver_notgt_rel_ver_patch() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
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
# X.(Y).X !> X.(Z).X
# ------------------------------
it_ret1_when_rel_ver_notgt_rel_ver_minor() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
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
# (Y).X.X > (Z).X.X
# ------------------------------
it_ret1_when_rel_ver_notgt_rel_ver_major() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_EIGHT_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}
