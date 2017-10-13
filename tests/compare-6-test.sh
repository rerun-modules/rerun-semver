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
RELEASE_VERSION_TWO_FOUR="2.4"

# The Plan
# --------
describe "compare-invalid-releases"

#
# comparison type: equals -- invalid release versions
#

# ------------------------------
# X.X == X.X ?
# ------------------------------
it_ret3_when_both_rel_ver_invalid_w_eq() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X < X.X ?
# ------------------------------
it_ret3_when_both_rel_ver_invalid_w_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
    --compare "lt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X > X.X ?
# ------------------------------
it_ret3_when_both_rel_ver_invalid_w_gt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X ~> X.X ? pess_patch
# ------------------------------
it_ret3_when_both_rel_ver_invalid_w_pess_patch() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
    --compare "pess_patch" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X ~> X.X ? pess_minor
# ------------------------------
it_ret3_when_both_rel_ver_invalid_w_pess_minor() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
    --compare "pess_minor" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X == X.X.X ?
# ------------------------------
it_ret3_when_left_rel_ver_invalid_w_eq() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
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
# X.X < X.X.X ?
# ------------------------------
it_ret3_when_left_rel_ver_invalid_w_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
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
# X.X > X.X.X ?
# ------------------------------
it_ret3_when_left_rel_ver_invalid_w_gt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
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
# X.X ~> X.X.X ? pess_patch
# ------------------------------
it_ret3_when_left_rel_ver_invalid_w_pess_patch() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
    --compare "pess_patch" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X ~> X.X.X ? pess_minor
# ------------------------------
it_ret3_when_left_rel_ver_invalid_w_pess_minor() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR" \
    --compare "pess_minor" \
    --right_version "$RELEASE_VERSION_TWO_FOUR_SIX") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X == X.X ?
# ------------------------------
it_ret3_when_right_rel_ver_invalid_w_eq() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "eq" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X < X.X ?
# ------------------------------
it_ret3_when_right_rel_ver_invalid_w_lt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "lt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X > X.X ?
# ------------------------------
it_ret3_when_right_rel_ver_invalid_w_gt() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "gt" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X ~> X.X ? pess_patch
# ------------------------------
it_ret3_when_right_rel_ver_invalid_w_pess_patch() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "pess_patch" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}

# ------------------------------
# X.X.X ~> X.X ? pess_minor
# ------------------------------
it_ret3_when_right_rel_ver_invalid_w_pess_minor() {
  local exitcode=
  $(rerun semver: compare \
    --left_version "$RELEASE_VERSION_TWO_FOUR_SIX" \
    --compare "pess_minor" \
    --right_version "$RELEASE_VERSION_TWO_FOUR") && {
    echo >&2 "rerun test command succeeded"; return 1
  } || {
    exitcode=$?; test $exitcode -eq 3
  } || {
    echo >&2 "rerun test command failed with exit code: $exitcode"; return 1
  }
}
