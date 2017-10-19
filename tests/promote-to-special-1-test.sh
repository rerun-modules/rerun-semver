#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m semver -p promote-to-special [--answers <>]
#

set -u

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

rerun() {
  command $RERUN -M $RERUN_MODULES "$@"
}

# Constants
DEFAULT_PROMOTE_SPECIAL="rc01"
DEFAULT_PROMOTE_RELEASE_VERSION="1.6.8"
DEFAULT_PROMOTE_RC_VERSION="1.6.9-${DEFAULT_PROMOTE_SPECIAL}"

DEFAULT_PROMOTE_SPECIAL_ERROR="unable to promote to special version, must specify input version without special"

DEFAULT_INVALID_INPUT_VERSION="a4-23.22"
DEFAULT_INVALID_INPUT_VERSION_ERROR="input version failed semver validation: ${DEFAULT_INVALID_INPUT_VERSION}"

# The Plan
# --------
describe "promote-to-special"

# ------------------------------
# X.X to X.X.X ?
# ------------------------------
it_errors_when_input_ver_invalid() {
  local promote_error=
  promote_error=$(rerun semver: promote-to-special \
    --input_version "$DEFAULT_INVALID_INPUT_VERSION" \
    --special "$DEFAULT_PROMOTE_SPECIAL" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$promote_error" | grep -F "$DEFAULT_INVALID_INPUT_VERSION_ERROR"
}

# ------------------------------
# X.X.X-(RC1) to X.X.X-(RC1) ?
# ------------------------------
it_errors_when_promoting_special_ver() {
  local promote_error=
  promote_error=$(rerun semver: promote-to-special \
    --input_version "$DEFAULT_PROMOTE_RC_VERSION" \
    --special "$DEFAULT_PROMOTE_SPECIAL" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
  } || true
  
  echo "$promote_error" | grep -F "$DEFAULT_PROMOTE_SPECIAL_ERROR"
}

# ------------------------------
# X.X.(1) to X.X.(2)-(RC1) ?
# ------------------------------
it_promotes_release_version_to_special() {
  local promote_output=
  promote_output=$(rerun semver: promote-to-special \
    --input_version "${DEFAULT_PROMOTE_RELEASE_VERSION}" \
    --special "$DEFAULT_PROMOTE_SPECIAL") || {
      echo >&2 "rerun test command failed with exit code: $?"; return 1
    }
  
  test "$promote_output" == "$DEFAULT_PROMOTE_RC_VERSION"
}
