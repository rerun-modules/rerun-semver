# execution examples
# RERUN_MODULES=$(pwd)/modules ./rerun semver:
# RERUN_MODULES=$(pwd)/modules ./rerun semver: bump-release --input_version '1.0.0' --segment 'major'
# RERUN_MODULES=$(pwd)/modules ./rerun semver: bump-special --input_version '1.0.0-rc01' --segment 'special' --special 'rc02'
# RERUN_MODULES=$(pwd)/modules ./rerun semver: compare --left_version '1.0.0' --compare 'eq' --right_version '1.0.0'
# RERUN_MODULES=$(pwd)/modules ./rerun semver: extract --input_version '1.4.8-rc01' --segment major
# RERUN_MODULES=$(pwd)/modules ./rerun semver: parse --input_string 'my-module-1.0.0-rc01.tar.gz' --trim_suffix '.tar.gz'
# RERUN_MODULES=$(pwd)/modules ./rerun semver: promote-to-release --input_version '1.0.4-rc01'
# RERUN_MODULES=$(pwd)/modules ./rerun semver: promote-to-special --input_version '1.0.4' --special 'rc01'
# RERUN_MODULES=$(pwd)/modules ./rerun semver: validate --input_version '1.4.8-rc01'
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan bump-release
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan bump-special
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan compare
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan extract
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan parse
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan promote-to-release
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan promote-to-special
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan validate

## modules

# rerun semver:
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-module \
  --description "utilities for semantic versions" \
  --module "semver"

## commands

# rerun semver: bump-release
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "bump-release" \
  --description "bump release version segment" \
  --module "semver"

# rerun semver: bump-special
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "bump-special" \
  --description "bump special version segment" \
  --module "semver"

# rerun semver: compare
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "compare" \
  --description "compare semantic versions" \
  --module "semver"

# rerun semver: extract
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "extract" \
  --description "extract semantic version segment" \
  --module "semver"

# rerun semver: parse
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "parse" \
  --description "parse input string for semantic version" \
  --module "semver"

# rerun semver: promote-to-release
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "promote-to-release" \
  --description "promote special version to release" \
  --module "semver"

# rerun semver: promote-to-special
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "promote-to-special" \
  --description "promote release version to special" \
  --module "semver"

# rerun semver: validate
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "validate" \
  --description "validate input semantic version" \
  --module "semver"

## options

# --input_string
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-option \
  --arg "true" \
  --command "parse" \
  --description "input string containing semantic version" \
  --export "false" \
  --long "input_string" \
  --module "semver" \
  --option "input_string" \
  --required "true"

# --input_version
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-option \
  --arg "true" \
  --command "extract,validate,bump-release,bump-special,promote-to-release,promote-to-special" \
  --description "input semantic version" \
  --export "false" \
  --long "input_version" \
  --module "semver" \
  --option "input_version" \
  --required "true"

# --trim_suffix
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-option \
  --arg "true" \
  --command "parse" \
  --description "suffix to trim from special version" \
  --export "false" \
  --long "trim_suffix" \
  --module "semver" \
  --option "trim_suffix" \
  --required "false"

# --left_version
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-option \
  --arg "true" \
  --command "compare" \
  --description "left side input version" \
  --export "false" \
  --long "left_version" \
  --module "semver" \
  --option "left_version" \
  --required "true"

# --right_version
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-option \
  --arg "true" \
  --command "compare" \
  --description "right side input version" \
  --export "false" \
  --long "right_version" \
  --module "semver" \
  --option "right_version" \
  --required "true"

# --compare
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-option \
  --arg "true" \
  --command "compare" \
  --description "comparison type (eq|lt|gt|pess_minor|pess_patch)" \
  --export "false" \
  --long "compare" \
  --module "semver" \
  --option "compare" \
  --required "true"

# --segment
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-option \
  --arg "true" \
  --command "extract,bump-release" \
  --description "version segment" \
  --export "false" \
  --long "segment" \
  --module "semver" \
  --option "segment" \
  --required "true"

# --special
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-option \
  --arg "true" \
  --command "bump-special,promote-to-special" \
  --description "special version" \
  --export "false" \
  --long "special" \
  --module "semver" \
  --option "special" \
  --required "true"
