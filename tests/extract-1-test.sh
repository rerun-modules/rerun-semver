#!/usr/bin/env roundup
#
#/ usage:  rerun stubbs:test -m semver -p extract [--answers <>]
#

# Helpers
# -------
[[ -f ./functions.sh ]] && . ./functions.sh

rerun() {
  command $RERUN -M $RERUN_MODULES "$@"
}

# Constants

DEFAULT_MAJOR_VERSION="4"
DEFAULT_MINOR_VERSION="2"
DEFAULT_PATCH_VERSION="8"
DEFAULT_SPECIAL_VERSION="rc01-33.34-alpha1"
DEFAULT_VALID_RELEASE_SEMVER="${DEFAULT_MAJOR_VERSION}.${DEFAULT_MINOR_VERSION}.${DEFAULT_PATCH_VERSION}"
DEFAULT_VALID_RC_SEMVER="${DEFAULT_VALID_RELEASE_SEMVER}-${DEFAULT_SPECIAL_VERSION}"

DEFAULT_INVALID_RELEASE_SEMVER="1.3-83"

DEFAULT_VALIDATION_FAILURE_ERROR="input version failed semver validation: ${DEFAULT_INVALID_RELEASE_SEMVER}"

# The Plan
# --------
describe "extract"

# ------------------------------
it_outputs_release_semver_major_version() {
  extracted_version=$(rerun semver: extract \
    --input_version "$DEFAULT_VALID_RELEASE_SEMVER" \
    --segment "major") || {
      echo >&2 "failed running rerun test command with exit code: $?"; return 1
    }
  
  test "$extracted_version" == "$DEFAULT_MAJOR_VERSION"
}
# ------------------------------
it_outputs_release_semver_minor_version() {
  extracted_version=$(rerun semver: extract \
    --input_version "$DEFAULT_VALID_RELEASE_SEMVER" \
    --segment "minor") || {
      echo >&2 "failed running rerun test command with exit code: $?"; return 1
    }
  
  test "$extracted_version" == "$DEFAULT_MINOR_VERSION"
}
# ------------------------------
it_outputs_release_semver_patch_version() {
  extracted_version=$(rerun semver: extract \
    --input_version "$DEFAULT_VALID_RELEASE_SEMVER" \
    --segment "patch") || {
      echo >&2 "failed running rerun test command with exit code: $?"; return 1
    }
  
  test "$extracted_version" == "$DEFAULT_PATCH_VERSION"
}
# ------------------------------
it_outputs_release_semver_special_ver_as_null() {
  extracted_version=$(rerun semver: extract \
    --input_version "$DEFAULT_VALID_RELEASE_SEMVER" \
    --segment "special") || {
      echo >&2 "failed running rerun test command with exit code: $?"; return 1
    }
  
  test -z "$extracted_version"
}
# ------------------------------
it_outputs_rc_semver_major_version() {
  extracted_version=$(rerun semver: extract \
    --input_version "$DEFAULT_VALID_RC_SEMVER" \
    --segment "major") || {
      echo >&2 "failed running rerun test command with exit code: $?"; return 1
    }
  
  test "$extracted_version" == "$DEFAULT_MAJOR_VERSION"
}
# ------------------------------
it_outputs_rc_semver_minor_version() {
  extracted_version=$(rerun semver: extract \
    --input_version "$DEFAULT_VALID_RC_SEMVER" \
    --segment "minor") || {
      echo >&2 "failed running rerun test command with exit code: $?"; return 1
    }
  
  test "$extracted_version" == "$DEFAULT_MINOR_VERSION"
}
# ------------------------------
it_outputs_rc_semver_patch_version() {
  extracted_version=$(rerun semver: extract \
    --input_version "$DEFAULT_VALID_RC_SEMVER" \
    --segment "patch") || {
      echo >&2 "failed running rerun test command with exit code: $?"; return 1
    }
  
  test "$extracted_version" == "$DEFAULT_PATCH_VERSION"
}
# ------------------------------
it_outputs_rc_semver_special_version() {
  extracted_version=$(rerun semver: extract \
    --input_version "$DEFAULT_VALID_RC_SEMVER" \
    --segment "special") || {
      echo >&2 "failed running rerun test command with exit code: $?"; return 1
    }
  
  test "$extracted_version" == "$DEFAULT_SPECIAL_VERSION"
}
# ------------------------------
it_errors_when_input_version_fails_validation() {
  validation_failure_error=$(rerun semver: extract \
    --input_version "$DEFAULT_INVALID_RELEASE_SEMVER" \
    --segment "major" 2>&1) && {
      echo >&2 "rerun test command succeeded"; return 1
    } || true
  
  echo "$validation_failure_error" | grep -F "$DEFAULT_VALIDATION_FAILURE_ERROR"
}
# ------------------------------
