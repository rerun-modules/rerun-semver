#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m semver -p bump-release [--answers <>]
#

set -u

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

rerun() {
  command $RERUN -M $RERUN_MODULES "$@"
}

# Constants
DEFAULT_BUMP_RELEASE_VERSION="1.6.8"
DEFAULT_BUMPED_RELEASE_VERSION_PATCH="1.6.9"
DEFAULT_BUMPED_RELEASE_VERSION_MINOR="1.7.0"
DEFAULT_BUMPED_RELEASE_VERSION_MAJOR="2.0.0"

DEFAULT_BUMP_RC_VERSION="1.6.8-rc01"

DEFAULT_INVALID_BUMP_SEGMENT="invalidtest"
DEFAULT_INVALID_BUMP_SEGMENT_ERROR="invalid segment type '${DEFAULT_INVALID_BUMP_SEGMENT}'"

DEFAULT_INVALID_INPUT_VERSION="a4-23.22"
DEFAULT_INVALID_INPUT_VERSION_ERROR="input version failed semver validation: ${DEFAULT_INVALID_INPUT_VERSION}"

DEFAULT_BUMP_SPECIAL_ERROR="unable to bump release version segment, input version contains special version"

# The Plan
# --------
describe "bump-release"

# ------------------------------
# X.X.X (?) X.X.X ?
# ------------------------------
it_errors_when_bump_segment_invalid() {
  local bump_error=
  bump_error=$(rerun semver: bump-release \
    --input_version "$DEFAULT_BUMP_RELEASE_VERSION" \
    --segment "$DEFAULT_INVALID_BUMP_SEGMENT" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_INVALID_BUMP_SEGMENT_ERROR"
}

# ------------------------------
# X.X to X.X.X ?
# ------------------------------
it_errors_when_input_ver_invalid() {
  local bump_error=
  bump_error=$(rerun semver: bump-release \
    --input_version "$DEFAULT_INVALID_INPUT_VERSION" \
    --segment "patch" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_INVALID_INPUT_VERSION_ERROR"
}

# ------------------------------
# X.X.(1)-(RC1) to X.X.(2) ?
# ------------------------------
it_errors_when_bumping_rc_using_patch() {
  local bump_error=
  bump_error=$(rerun semver: bump-release \
    --input_version "${DEFAULT_BUMP_RC_VERSION}" \
    --segment "patch" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_SPECIAL_ERROR"
}

# ------------------------------
# X.(1).X-(RC1) to X.(2).X ?
# ------------------------------
it_errors_when_bumping_rc_using_minor() {
  local bump_error=
  bump_error=$(rerun semver: bump-release \
    --input_version "${DEFAULT_BUMP_RC_VERSION}" \
    --segment "minor" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_SPECIAL_ERROR"
}

# ------------------------------
# (1).X.X-(RC1) to (2).X.X ?
# ------------------------------
it_errors_when_bumping_rc_using_major() {
  local bump_error=
  bump_error=$(rerun semver: bump-release \
    --input_version "${DEFAULT_BUMP_RC_VERSION}" \
    --segment "major" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_SPECIAL_ERROR"
}

# ------------------------------
# X.X.(1) to X.X.(2) ?
# ------------------------------
it_bumps_rel_to_new_rel_using_patch() {
  local bump_output=
  bump_output=$(rerun semver: bump-release \
    --input_version "${DEFAULT_BUMP_RELEASE_VERSION}" \
    --segment "patch") || {
      echo >&2 "rerun test command failed with exit code: $?"; return 1
    }
  
  test "$bump_output" == "$DEFAULT_BUMPED_RELEASE_VERSION_PATCH"
}

# ------------------------------
# X.(1).X to X.(2).0 ?
# ------------------------------
it_bumps_rel_to_new_rel_using_minor() {
  local bump_output=
  bump_output=$(rerun semver: bump-release \
    --input_version "${DEFAULT_BUMP_RELEASE_VERSION}" \
    --segment "minor") || {
      echo >&2 "rerun test command failed with exit code: $?"; return 1
    }
  
  test "$bump_output" == "$DEFAULT_BUMPED_RELEASE_VERSION_MINOR"
}

# ------------------------------
# (1).X.X to (2).0.0 ?
# ------------------------------
it_bumps_rel_to_new_rel_using_major() {
  local bump_output=
  bump_output=$(rerun semver: bump-release \
    --input_version "${DEFAULT_BUMP_RELEASE_VERSION}" \
    --segment "major") || {
      echo >&2 "rerun test command failed with exit code: $?"; return 1
    }
  
  test "$bump_output" == "$DEFAULT_BUMPED_RELEASE_VERSION_MAJOR"
}
