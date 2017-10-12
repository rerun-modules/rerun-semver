#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m semver -p validate [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

rerun() {
  command $RERUN -M $RERUN_MODULES "$@"
}

# Constants

DEFAULT_VALID_RELEASE_SEMVER="1.3.8"
DEFAULT_VALID_RC_SEMVER="1.3.8-rc01.22-alpha-5"
DEFAULT_INVALID_RELEASE_SEMVER="A23.22"
DEFAULT_INVALID_RC_SEMVER="B81H-882.4"

# The Plan
# --------
describe "validate"

# ------------------------------
it_returns_zero_for_valid_release_semver() {
  $(rerun semver: validate \
    --input_version "$DEFAULT_VALID_RELEASE_SEMVER") || {
      echo >&2 "rerun test command failed with exit code: $?"
    }
}
# ------------------------------
it_returns_zero_for_valid_rc_semver() {
  $(rerun semver: validate \
    --input_version "$DEFAULT_VALID_RC_SEMVER") || {
      echo >&2 "rerun test command failed with exit code: $?"
    }
}
# ------------------------------
it_errors_for_invalid_release_semver() {
  $(rerun semver: validate \
    --input_version "$DEFAULT_INVALID_RELEASE_SEMVER") && {
      echo >&2 "rerun test command succeeded"; return 1
    } || true
}
# ------------------------------
it_errors_for_invalid_rc_semver() {
  $(rerun semver: validate \
    --input_version "$DEFAULT_INVALID_RC_SEMVER") && {
      echo >&2 "rerun test command succeeded"; return 1
    } || true
}
# ------------------------------
