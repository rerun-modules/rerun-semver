#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m semver -p bump-special [--answers <>]
#

set -u

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

DEFAULT_BUMP_RC_VERSION="1.6.8-${DEFAULT_BUMP_SPECIAL}"
DEFAULT_BUMPED_RC_VERSION_SPECIAL="1.6.8-${DEFAULT_BUMPED_SPECIAL}"

DEFAULT_INVALID_INPUT_VERSION="a4-23.22"
DEFAULT_INVALID_INPUT_VERSION_ERROR="input version failed semver validation: ${DEFAULT_INVALID_INPUT_VERSION}"

DEFAULT_BUMP_RELEASE_INPUT_SPECIAL_ERROR="cannot bump special version, must specify input version with valid special"

# The Plan
# --------
describe "bump-special"

# ------------------------------
# X.X to X.X.X ?
# ------------------------------
it_errors_when_input_ver_invalid() {
  local bump_error=
  bump_error=$(rerun semver: bump-special \
    --input_version "$DEFAULT_INVALID_INPUT_VERSION" \
    --special "$DEFAULT_BUMP_SPECIAL" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_INVALID_INPUT_VERSION_ERROR"
}

# ------------------------------
# X.X.X to X.X.X-(X) ?
# ------------------------------
it_errors_when_bumping_release() {
  local bump_error=
  bump_error=$(rerun semver: bump-special \
    --input_version "${DEFAULT_BUMP_RELEASE_VERSION}" \
    --special "${DEFAULT_BUMP_SPECIAL}" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$bump_error" | grep -F "$DEFAULT_BUMP_RELEASE_INPUT_SPECIAL_ERROR"
}

# ------------------------------
# X.X.X-(RC1) to X.X.X-(RC2) ?
# ------------------------------
it_bumps_special_to_any_special() {
  local bump_output=
  bump_output=$(rerun semver: bump-special \
    --input_version "${DEFAULT_BUMP_RC_VERSION}" \
    --special "$DEFAULT_BUMPED_SPECIAL") || {
      echo >&2 "rerun test command failed with exit code: $?"; return 1
    }
  
  test "$bump_output" == "$DEFAULT_BUMPED_RC_VERSION_SPECIAL"
}
