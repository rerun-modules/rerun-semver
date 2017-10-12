# Shell functions for the semver module.
#/ usage: source RERUN_MODULE_DIR/lib/functions.sh command
#

# Read rerun's public functions
. $RERUN || {
    echo >&2 "ERROR: Failed sourcing rerun function library: \"$RERUN\""
    return 1
}

# Check usage. Argument should be command name.
[[ $# = 1 ]] || rerun_option_usage

# Source the option parser script.
#
if [[ -r $RERUN_MODULE_DIR/commands/$1/options.sh ]] 
then
    . $RERUN_MODULE_DIR/commands/$1/options.sh || {
        rerun_die "Failed loading options parser."
    }
fi

# - - -
# Your functions declared here.
# - - -

#
# semantic versioning 2.0
# semver.org
#

# un-escaped regex (with capture groups, no outside boundary)
# ([0-9]{1,})\.([0-9]{1,})(\.([0-9]{1,})(-(([0-9a-zA-Z]{1,}[.-]{0,1}){0,}[0-9a-zA-Z]{1,})){0,1}){0,1}
#
# un-escaped regex (with capture groups)
# ^([0-9]{1,})\.([0-9]{1,})(\.([0-9]{1,})(-(([0-9a-zA-Z]{1,}[.-]{0,1}){0,}[0-9a-zA-Z]{1,})){0,1}){0,1}$
#
# sed-escaped, basic (POSIX compliant) regex (with capture groups)
# ^\([0-9]\{1,\}\)\.\([0-9]\{1,\}\)\(\.\([0-9]\{1,\}\)\(-\(\([0-9a-zA-Z]\{1,\}[.-]\{0,1\}\)\{0,\}[0-9a-zA-Z]\{1,\}\)\)\{0,1\}\)\{0,1\}$
#
# capture groups
# major.minor.patch-special
# 1) major
# 2) minor
# 4) patch
# 6) special

# Constants

SEMVER_RE='([0-9]{1,})\.([0-9]{1,})\.([0-9]{1,})(-(([0-9a-zA-Z]{1,}[.-]{0,1}){0,}[0-9a-zA-Z]{1,})){0,1}'
SEMVER_RE_W_BOUNDARIES="^${SEMVER_RE}$"

SEMVER_RE_ESCAPED='\([0-9]\{1,\}\)\.\([0-9]\{1,\}\)\.\([0-9]\{1,\}\)\(-\(\([0-9a-zA-Z]\{1,\}[.-]\{0,1\}\)\{0,\}[0-9a-zA-Z]\{1,\}\)\)\{0,1\}'
SEMVER_RE_ESCAPED_W_BOUNDARIES="^${SEMVER_RE_ESCAPED}$"

# parses an input string for a semantic version
# args:
#   1 - input string
#   2 - (optional) suffix to remove
semver_parse() {
  # input variables
  
  local input_string="${1:-}"
  local remove_suffix="${2:-}"
  
  # function variables
  
  local parsed_version=
  
  # validate input
  
  if [ -z "$input_string" ]; then
    rerun_log "error" "input string is null or empty"; return 2
  fi
  
  if [ -n "$remove_suffix" ]; then
    input_string="${input_string%$remove_suffix}"
  fi
  
  # parse version
  
  parsed_version=$(echo $input_string | grep -Eo "$SEMVER_RE") || {
    rerun_log "error" "failed to parse input string: $input_string"; return 1
  }
  
  # check for null
  
  if [ -z "$parsed_version" ]; then
    rerun_log "error" "parsed version is null or empty"; return 1
  fi
  
  # print to output
  
  echo "$parsed_version"
  
  return 0
}


# validates that an input version is a semver
# args:
#   1 - input version
# return codes:
#   0 - valid semver
#   1 - invalid semver
#   2 - input error
semver_validate() {
  # input variables
  
  local input_version="${1:-}"
  
  # validate input
  
  if [ -z "$input_version" ]; then
    rerun_log "error" "input version is null or empty"; return 2
  fi
  
  # parse version
  
  parsed_version=$(echo $input_version | grep -E "$SEMVER_RE_W_BOUNDARIES") || return 1
  
  # validate version
  
  test "$parsed_version" == "$input_version" || return 1
  
  return 0
}


# extracts specified segment from semantic version
# args
#   1 - version segment
#     major | minor | patch | special
#   2 - input version
semver_extract() {
  # input variables
  
  local version_segment="${1:-}"
  local input_version="${2:-}"
  
  # function variables
  
  local extracted_version=
  
  # validate input
   
  case "$version_segment" in
    "major"|"minor"|"patch"|"special")
      ;;
    *)
      rerun_log "error" "invalid segment type '$version_segment', valid options are: major | minor | patch | special"; return 2
      ;;
  esac
  
  if [ -z "$input_version" ]; then
    echo >&2 "input version is empty"; return 2
  fi
  
  # validate input version
  
  semver_validate "$input_version" || {
    rerun_log "error" "input version failed semver validation: $input_version"; return 1
  }
  
  # extract version
  
  case "$version_segment" in
    "major")
      extracted_version=$(echo $input_version | sed -e "s#$SEMVER_RE_ESCAPED_W_BOUNDARIES#\1#") || {
        rerun_log "error" "failed to extract major version"; return 1
      }
      ;;
    "minor")
      extracted_version=$(echo $input_version | sed -e "s#$SEMVER_RE_ESCAPED_W_BOUNDARIES#\2#") || {
        rerun_log "error" "failed to extract minor version"; return 1
      }
      ;;
    "patch")
      extracted_version=$(echo $input_version | sed -e "s#$SEMVER_RE_ESCAPED_W_BOUNDARIES#\3#") || {
        rerun_log "error" "failed to extract patch version"; return 1
      }
      ;;
    "special")
      extracted_version=$(echo $input_version | sed -e "s#$SEMVER_RE_ESCAPED_W_BOUNDARIES#\5#") || {
        rerun_log "error" "failed to extract patch version"; return 1
      }
      ;;
    *)
      rerun_log "error" "invalid segment type '$version_segment' somehow bypassed validation"; return 2
      ;;
  esac
  
  # validate extracted version
  #   if the regex fails, the value gets returned unchanged
  #   thus if the extracted value == the original value, it failed to extract
  test "$extracted_version" != "$input_version" || {
    echo >&2 "extracted version matches the input version, input version may be malformed: $input_version"; return 1
  }
  
  # output extracted version

  echo "$extracted_version"
  
  return 0
}


# compares two semantic versions using specified type
# args:
#   1 - left version (version under test)
#   2 - comparison type:
#     EQ
#     LT
#     GT
#     pess_minor
#     pess_patch
#   3 - right version (version constraint or target)
# return codes:
#   0 - comparison matches
#   1 - comparison does not match
#   2 - input error
#   3 - parse error
#   4 - logic error
semver_compare() {
  # input variables
  
  local left_version="${1:-}"
  local comparison_type="${2:-}"
  local right_version="${3:-}"
  
  # validate input
  
  if [ -z "$comparison_type" ]; then
    rerun_log "error" "comparison type is null or empty"; return 2
  fi
  if [ -z "$left_version" ]; then
    rerun_log "error" "left version is null or empty"; return 2
  fi
  if [ -z "$right_version" ]; then
    rerun_log "error" "right version is null or empty"; return 2
  fi
  
  # parse left version
  
  local left_major=
  left_major="$(semver_extract "major" "$left_version")" || {
    rerun_log "error" "failed to extract semver major from left version: $left_version"; return 3
  }
  if [ -z "$left_major" ]; then
    rerun_log "error" "left major version is null or empty"; return 3
  fi
  
  local left_minor=
  left_minor="$(semver_extract "minor" "$left_version")" || {
    rerun_log "error" "failed to extract semver minor from left version: $left_version"; return 3
  }
  if [ -z "$left_minor" ]; then
    rerun_log "error" "left minor version is null or empty"; return 3
  fi
  
  local left_patch=
  left_patch="$(semver_extract "patch" "$left_version")" || {
    rerun_log "error" "failed to extract semver patch from left version: $left_version"; return 3
  }
  if [ -z "$left_patch" ]; then
    rerun_log "error" "left patch version is null or empty"; return 3
  fi
  
  local left_special=
  left_special="$(semver_extract "special" "$left_version")" || {
    rerun_log "error" "failed to extract semver special from left version: $left_version"; return 3
  }
  
  # parse right version
  
  local right_major=
  right_major="$(semver_extract "major" "$right_version")" || {
    rerun_log "error" "failed to extract semver major from right version: $right_version"; return 3
  }
  if [ -z "$right_major" ]; then
    rerun_log "error" "right major version is null or empty"; return 3
  fi
  
  local right_minor=
  right_minor="$(semver_extract "minor" "$right_version")" || {
    rerun_log "error" "failed to extract semver minor from right version: $right_version"; return 3
  }
  if [ -z "$right_minor" ]; then
    rerun_log "error" "right minor version is null or empty"; return 3
  fi
  
  local right_patch=
  right_patch="$(semver_extract "patch" "$right_version")" || {
    rerun_log "error" "failed to extract semver patch from right version: $right_version"; return 3
  }
  if [ -z "$right_patch" ]; then
    rerun_log "error" "right patch version is null or empty"; return 3
  fi
  
  local right_special=
  right_special="$(semver_extract "special" "$right_version")" || {
    rerun_log "error" "failed to extract semver special from right version: $right_version"; return 3
  }
  
  case $comparison_type in
    "eq")
      if [ $left_major -ne $right_major ]; then
        return 1
      fi

      if [ $left_minor -ne $right_minor ]; then
        return 1
      fi

      if [ $left_patch -ne $right_patch ]; then
        return 1
      fi

      if [ "_$left_special" != "_$right_special" ]; then
        return 1
      fi
      
      return 0
      ;;
    "lt")
      # check major
      if [ $left_major -lt $right_major ]; then
        return 0
      elif [ $left_major -gt $right_major ]; then
        return 1
      elif [ $left_major -eq $right_major ]; then
        # major matches, check minor
        if [ $left_minor -lt $right_minor ]; then
          return 0
        elif [ $left_minor -gt $right_minor ]; then
          return 1
        elif [ $left_minor -eq $right_minor ]; then
          # minor matches, check patch
          if [ $left_patch -lt $right_patch ]; then
            return 0
          elif [ $left_patch -gt $right_patch ]; then
            return 1
          elif [ $left_patch -eq $right_patch ]; then
            # patch matches, check special
            # special is considered a 'lesser' version than
            # a version without a special (e.g. 1.0.0 is assumed newer than 1.0.0-alpha)
            if [ "_$left_special"  == "_" ] && [ "_$right_special"  == "_" ]; then
              # both specials are empty, versions match
              return 1
            elif [ "_$left_special"  == "_" ] && [ "_$right_special"  != "_" ]; then
              # version A does not have special, version B does
              return 1
            elif [ "_$left_special"  != "_" ] && [ "_$right_special"  == "_" ]; then
              # version A has special, version B does not
              return 0
            elif [ "_$left_special" "<" "_$right_special" ]; then
              # version A special is ASCII less-than version B special
              return 0
            elif [ "_$left_special" ">" "_$right_special" ]; then
              # version A special is ASCII greater-than version B special
              return 1
            elif [ "$left_special" == "$right_special" ]; then
              # version A special matches version B special
              # this must be tested after doing the 'empty' test above
              return 1
            fi
          fi
        fi
      fi
      
      # hit an invalid logic path, error!
      return 4
      ;;
    "gt")
      # check major
      if [ $left_major -gt $right_major ]; then
        return 0
      elif [ $left_major -lt $right_major ]; then
        return 1
      elif [ $left_major -eq $right_major ]; then
        # major matches, check minor
        if [ $left_minor -gt $right_minor ]; then
          return 0
        elif [ $left_minor -lt $right_minor ]; then
          return 1
        elif [ $left_minor -eq $right_minor ]; then
          # minor matches, check patch
          if [ $left_patch -gt $right_patch ]; then
            return 0
          elif [ $left_patch -lt $right_patch ]; then
            return 1
          elif [ $left_patch -eq $right_patch ]; then
            # patch matches, check special
            # special is considered a 'lesser' version than
            # a version without a special (e.g. 1.0.0 is assumed newer than 1.0.0-alpha)
            if [ "_$left_special"  == "_" ] && [ "_$right_special"  == "_" ]; then
              # both specials are empty, versions match
              return 1
            elif [ "_$left_special"  == "_" ] && [ "_$right_special"  != "_" ]; then
              # version A does not have special, version B does
              return 0
            elif [ "_$left_special"  != "_" ] && [ "_$right_special"  == "_" ]; then
              # version A has special, version B does not
              return 1
            elif [ "_$left_special" "<" "_$right_special" ]; then
              # version A special is ASCII less-than version B special
              return 1
            elif [ "_$left_special" ">" "_$right_special" ]; then
              # version A special is ASCII greater-than version B special
              return 0
            elif [ "_$left_special" == "_$right_special" ]; then
              # version A special matches version B special
              # this must be tested after doing the 'empty' test above
              return 1
            fi
          fi
        fi
      fi
      
      # hit an invalid logic path, error!
      return 4
      ;;
    "pess_minor")
      # check major
      if [ $left_major -ne $right_major ]; then
        # majors don't match, no further verification needed
        return 1
      # major matches, check minor
      elif [ $left_minor -ge $right_minor ]; then
        # minor A is ~> minor B
        return 0
      elif [ $left_minor -lt $right_minor ]; then
        # minor A is < minor B
        return 1
      fi
      ;;
    "pess_patch")
      # check major
      if [ $left_major -ne $right_major ]; then
        # majors don't match, no further verification needed
        return 1
      # major matches, check minor
      elif [ $left_minor -ne $right_minor ]; then
        # minors don't match, no further verification needed
        return 1
      # minor matches, check patch
      elif [ $left_patch -gt $right_patch ]; then
        # patch A is > patch B, no further verification needed
        return 0
      elif [ $left_patch -eq $right_patch ]; then
        # patch matches, check special
        # special is considered a 'lesser' version than
        # a version without a special (e.g. 1.0.0 is assumed newer than 1.0.0-alpha)
        if [ "_$left_special"  == "_" ] && [ "_$right_special"  == "_" ]; then
          # both specials are empty, versions match
          return 0
        elif [ "_$left_special"  == "_" ] && [ "_$right_special"  != "_" ]; then
          # version A does not have special, version B does
          return 0
        elif [ "_$left_special"  != "_" ] && [ "_$right_special"  == "_" ]; then
          # version A has special, version B does not
          return 1
        elif [ "_$left_special" "<" "_$right_special" ]; then
          # version A special is ASCII less-than version B special
          return 1
        elif [ "_$left_special" ">" "_$right_special" ]; then
          # version A special is ASCII greater-than version B special
          return 0
        elif [ "_$left_special" == "_$right_special" ]; then
          # version A special matches version B special
          # this must be tested after doing the 'empty' test above
          return 0
        fi
      elif [ $left_patch -lt $right_patch ]; then
        # patch A is < patch B
        return 1
      fi
      ;;
    *)
      echo >&2 "comparison type is unsupported: $comparison_type"; return 2
      ;;
  esac
  
  return 4
}
