#!/bin/bash

####################################################################################################
#
# Calls github-pages executable to build the site using allowed plugins and supported configuration
#
####################################################################################################

set -e

SOURCE_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_SOURCE
DESTINATION_DIRECTORY=${GITHUB_WORKSPACE}/$INPUT_DESTINATION
PAGES_GEM_HOME=$BUNDLE_APP_CONFIG
GITHUB_PAGES_BIN=$PAGES_GEM_HOME/bin/github-pages

# Check if Gemfile's dependencies are satisfied or print a warning
if test -e "$SOURCE_DIRECTORY/Gemfile" && ! bundle check --dry-run --gemfile "$SOURCE_DIRECTORY/Gemfile"; then
  echo "::warning:: github-pages can't satisfy your Gemfile's dependencies."
fi

echo "::warning:: github-pages can't satisfy your Gemfile's dependencies."

# Set environment variables required by supported plugins
export JEKYLL_ENV="production"
export JEKYLL_GITHUB_TOKEN=$INPUT_TOKEN
export PAGES_REPO_NWO=$GITHUB_REPOSITORY
export JEKYLL_BUILD_REVISION=$INPUT_BUILD_REVISION
export PAGES_API_URL=$GITHUB_API_URL

# Set verbose flag
if [ "$INPUT_VERBOSE" = 'true' ]; then
  VERBOSE='--verbose'
else
  VERBOSE=''
fi

# Set future flag
if [ "$INPUT_FUTURE" = 'true' ]; then
  FUTURE='--future'
else
  FUTURE=''
fi

cd "$PAGES_GEM_HOME"

echo "::warning:: start to build"
(
    set +e
    $GITHUB_PAGES_BIN build "$VERBOSE" "$FUTURE" --source "$SOURCE_DIRECTORY" --destination "$DESTINATION_DIRECTORY" 2>&1
)

# Capture the exit code in a variable
exit_code=$?

# Check if the exit code indicates an error
if [ $exit_code -ne 0 ]; then
    echo "::error:: $output exit: $exit_code"
fi

echo "::warning:: finished build"
