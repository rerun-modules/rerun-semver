#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m semver -p parse [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

rerun() {
  command $RERUN -M $RERUN_MODULES "$@"
}

# Constants
DEFAULT_SPECIAL_VERSION="rc01"
DEFAULT_RELEASE_VERSION="1.0.2"
DEFAULT_RC_VERSION="${DEFAULT_RELEASE_VERSION}-${DEFAULT_SPECIAL_VERSION}"
DEFAULT_MALFORMED_VERSION="AA83j"

DEFAULT_INPUT_STRING_PREFIX="my-module"
DEFAULT_INPUT_STRING_SUFFIX=".tar.gz"

# input strings
## release
DEFAULT_INPUT_STRING_WITH_RELEASE_VERSION="${DEFAULT_INPUT_STRING_PREFIX}-${DEFAULT_RELEASE_VERSION}${DEFAULT_INPUT_STRING_SUFFIX}"
## rc
DEFAULT_INPUT_STRING_WITH_RC_VERSION="${DEFAULT_INPUT_STRING_PREFIX}-${DEFAULT_RC_VERSION}${DEFAULT_INPUT_STRING_SUFFIX}"
## malformed
DEFAULT_INPUT_STRING_WITH_MALFORMED_VERSION="${DEFAULT_INPUT_STRING_PREFIX}-${DEFAULT_MALFORMED_VERSION}${DEFAULT_INPUT_STRING_SUFFIX}"

# parsed versions
## release
DEFAULT_PARSED_RELEASE_VERSION="${DEFAULT_RELEASE_VERSION}"
## rc
DEFAULT_PARSED_RC_VERSION="${DEFAULT_RC_VERSION}"
DEFAULT_PARSED_RC_VERSION_WITH_SUFFIX="${DEFAULT_RC_VERSION}${DEFAULT_INPUT_STRING_SUFFIX}"

# The Plan
# --------
describe "parse"

# ------------------------------
it_parses_release_semver() {
  parsed_version=$(rerun semver: parse \
    --input_string "$DEFAULT_INPUT_STRING_WITH_RELEASE_VERSION") || {
      echo >&2 "rerun test call failed with exit code: $?"; return 1
    }
  test "$parsed_version" == "$DEFAULT_PARSED_RELEASE_VERSION"
}
# ------------------------------
it_parses_rc_semver_and_leaves_suffix() {
  parsed_version=$(rerun semver: parse \
    --input_string "$DEFAULT_INPUT_STRING_WITH_RC_VERSION") || {
      echo >&2 "rerun test call failed with exit code: $?"; return 1
    }
  test "$parsed_version" == "$DEFAULT_PARSED_RC_VERSION_WITH_SUFFIX"
}
# ------------------------------
it_parses_rc_semver_and_trims_suffix() {
  parsed_version=$(rerun semver: parse \
    --input_string "$DEFAULT_INPUT_STRING_WITH_RC_VERSION" \
    --trim_suffix "$DEFAULT_INPUT_STRING_SUFFIX") || {
      echo >&2 "rerun test call failed with exit code: $?"; return 1
    }
  test "$parsed_version" == "$DEFAULT_PARSED_RC_VERSION"
}
# ------------------------------
it_errors_when_semver_is_malformed() {
  version_malformed_error=$(rerun semver: parse \
    --input_string "$DEFAULT_INPUT_STRING_WITH_MALFORMED_VERSION" 2>&1) && {
      echo >&2 "rerun test call passed"; return 1
    } || true
  echo "$version_malformed_error" | grep -F "failed to parse input string: ${DEFAULT_INPUT_STRING_WITH_MALFORMED_VERSION}"
}
# ------------------------------
