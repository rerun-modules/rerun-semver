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
describe "compare-release-equals-release"

#
# comparison type: equals -- release versions
#

# ------------------------------
# X.X.X == X.X.X ?
# ------------------------------
it_ret0_when_rel_ver_eq_rel_ver() {
  rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX"
}

# ------------------------------
# X.X.(1) == X.X.(2) ?
# ------------------------------
it_ret1_when_rel_patch_ver_lt_rel_patch_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_EIGHT") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.(2) == X.X.(1) ?
# ------------------------------
it_ret1_when_rel_patch_ver_gt_rel_patch_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_EIGHT" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.(1).X == X.(2).X ?
# ------------------------------
it_ret1_when_rel_minor_ver_lt_rel_minor_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_TWO_SIX_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.(2).X == X.(1).X ?
# ------------------------------
it_ret1_when_rel_minor_ver_gt_rel_minor_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_SIX_SIX" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# (1).X.X == (2).X.X ?
# ------------------------------
it_ret1_when_rel_major_ver_lt_rel_major_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_EIGHT_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# (2).X.X == (1).X.X ?
# ------------------------------
it_ret1_when_rel_major_ver_gt_rel_major_ver() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_EIGHT_FOUR_SIX" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 1
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}
