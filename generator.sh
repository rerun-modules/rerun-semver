# execution examples
# RERUN_MODULES=$(pwd)/modules ./rerun semver:
# RERUN_MODULES=$(pwd)/modules ./rerun semver: extract --input_version '1.4.8-rc01' --segment major
# RERUN_MODULES=$(pwd)/modules ./rerun semver: compare --left_version '1.0.0' --equals --right_version '1.0.0'
# RERUN_MODULES=$(pwd)/modules ./rerun semver: parse --input_string 'my-module-1.0.0-rc01.tar.gz' --trim_suffix '.tar.gz'
# RERUN_MODULES=$(pwd)/modules ./rerun semver: validate --input_version '1.4.8-rc01'
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan parse
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan compare
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan extract
# RERUN_MODULES=$(pwd)/modules ./rerun stubbs: test --module semver --plan validate

# rerun semver:
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-module \
  --description "utilities for semantic versions" \
  --module "semver"

# rerun semver: compare
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "compare" \
  --description "compare semantic versions" \
  --module "semver"

# rerun semver: parse
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "parse" \
  --description "parse input string for semantic version" \
  --module "semver"

# rerun semver: validate
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "validate" \
  --description "validate input semantic version" \
  --module "semver"

# rerun semver: extract
RERUN_MODULES=$(pwd)/modules ./rerun stubbs: \
  add-command \
  --command "extract" \
  --description "extract semantic version segment" \
  --module "semver"

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
  --command "extract,validate" \
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
  --command "extract" \
  --description "version segment to extract (major|minor|patch|special)" \
  --export "false" \
  --long "segment" \
  --module "semver" \
  --option "segment" \
  --required "true"
