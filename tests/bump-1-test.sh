#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m semver -p bump [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

rerun() {
  command $RERUN -M $RERUN_MODULES "$@"
}

# Constants
DEFAULT_BUMP_SPECIAL="rc01"
DEFAULT_BUMPED_SPECIAL="rc02"

DEFAULT_BUMP_RELEASE_VERSION="1.6.8"
DEFAULT_BUMPED_RELEASE_VERSION_PATCH="1.6.9"
DEFAULT_BUMPED_RELEASE_VERSION_MINOR="1.7.0"
DEFAULT_BUMPED_RELEASE_VERSION_MAJOR="2.0.0"

DEFAULT_BUMP_RC_VERSION="1.6.8-${DEFAULT_BUMP_SPECIAL}"
DEFAULT_BUMPED_RC_VERSION_SPECIAL="1.6.8-${DEFAULT_BUMPED_SPECIAL}"

DEFAULT_INVALID_BUMP_SEGMENT="invalidtest"
DEFAULT_INVALID_BUMP_SEGMENT_ERROR="invalid segment type '${DEFAULT_INVALID_BUMP_SEGMENT}'"

DEFAULT_INVALID_INPUT_VERSION="a4-23.22"
DEFAULT_INVALID_INPUT_VERSION_ERROR="input version failed semver validation: ${DEFAULT_INVALID_INPUT_VERSION}"

DEFAULT_BUMP_MAJOR_SPECIAL_ERROR="unable to bump major version, input version contains special version"
DEFAULT_BUMP_MINOR_SPECIAL_ERROR="unable to bump minor version, input version contains special version"
DEFAULT_BUMP_PATCH_SPECIAL_ERROR="unable to bump patch version, input version contains special version"

DEFAULT_BUMP_RELEASE_INPUT_SPECIAL_ERROR="cannot bump special version, must specify input version with valid special"
DEFAULT_BUMP_RC_MISSING_SPECIAL_ERROR="cannot automatically bump special version, must specify new special version"

# The Plan
# --------
describe "bump"

# ------------------------------
# X.X.X (?) X.X.X ?
# ------------------------------
it_errors_when_bump_segment_invalid() {
  local bump_error=
  bump_error=$(rerun semver: bump \
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
  bump_error=$(rerun semver: bump \
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
  bump_error=$(rerun semver: bump \
    --input_version "${DEFAULT_BUMP_RC_VERSION}" \
    --segment "patch" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_PATCH_SPECIAL_ERROR"
}

# ------------------------------
# X.(1).X-(RC1) to X.(2).X ?
# ------------------------------
it_errors_when_bumping_rc_using_minor() {
  local bump_error=
  bump_error=$(rerun semver: bump \
    --input_version "${DEFAULT_BUMP_RC_VERSION}" \
    --segment "minor" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_MINOR_SPECIAL_ERROR"
}

# ------------------------------
# (1).X.X-(RC1) to (2).X.X ?
# ------------------------------
it_errors_when_bumping_rc_using_major() {
  local bump_error=
  bump_error=$(rerun semver: bump \
    --input_version "${DEFAULT_BUMP_RC_VERSION}" \
    --segment "major" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_MAJOR_SPECIAL_ERROR"
}

# ------------------------------
# X.X.X-(RC1) to X.X.X-() ?
# ------------------------------
it_errors_when_bumping_rc_with_null_special() {
  local bump_error=
  bump_error=$(rerun semver: bump \
    --input_version "${DEFAULT_BUMP_RC_VERSION}" \
    --segment "special" \
    --special "" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_RC_MISSING_SPECIAL_ERROR"
}

# ------------------------------
# X.X.X to X.X.X-() ?
# ------------------------------
it_errors_when_bumping_rel_with_null_special() {
  local bump_error=
  bump_error=$(rerun semver: bump \
    --input_version "${DEFAULT_BUMP_RELEASE_VERSION}" \
    --segment "special" \
    --special "" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_RELEASE_INPUT_SPECIAL_ERROR"
}

# ------------------------------
# X.X.X to X.X.X-(X) ?
# ------------------------------
it_errors_when_bumping_rel_with_any_special() {
  local bump_error=
  bump_error=$(rerun semver: bump \
    --input_version "${DEFAULT_BUMP_RELEASE_VERSION}" \
    --segment "special" \
    --special "${DEFAULT_SPECIAL_VERSION}" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_RELEASE_INPUT_SPECIAL_ERROR"
}

# ------------------------------
# X.X.(1) to X.X.(2) ?
# ------------------------------
it_bumps_rel_to_new_rel_using_patch() {
  local bump_output=
  bump_output=$(rerun semver: bump \
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
  bump_output=$(rerun semver: bump \
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
  bump_output=$(rerun semver: bump \
    --input_version "${DEFAULT_BUMP_RELEASE_VERSION}" \
    --segment "major") || {
      echo >&2 "rerun test command failed with exit code: $?"; return 1
    }
  
  test "$bump_output" == "$DEFAULT_BUMPED_RELEASE_VERSION_MAJOR"
}

# ------------------------------
# X.X.X-(RC1) to X.X.X-(RC2) ?
# ------------------------------
it_bumps_rc_to_new_rc_using_special() {
  local bump_output=
  bump_output=$(rerun semver: bump \
    --input_version "${DEFAULT_BUMP_RC_VERSION}" \
    --segment "special" \
    --special "$DEFAULT_BUMPED_SPECIAL") || {
      echo >&2 "rerun test command failed with exit code: $?"; return 1
    }
  
  test "$bump_output" == "$DEFAULT_BUMPED_RC_VERSION_SPECIAL"
}
