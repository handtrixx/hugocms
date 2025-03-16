#!/bin/bash

# check for environment variable STAGE
if [ -z "$STAGE" ]; then
  echo "STAGE is not set. Exiting."
  exit 1
fi

# check for environment variable HUGO_THEME_GIT_URL
if [ -z "$HUGO_THEME_GIT_URL" ]; then
  echo "HUGO_THEME_GIT_URL is not set. Exiting."
  exit 1
else
  if [ -d "themes/theme" ]; then
    echo "Removing existing content directory"
    rm -rf themes/theme
  fi
  echo "Cloning theme from $HUGO_THEME_GIT_URL"
  git clone $HUGO_THEME_GIT_URL themes/theme
fi

# check for environment variable HUGO_CONTENT_GITURL
if [ -z "$HUGO_CONTENT_GIT_URL" ]; then
  echo "HUGO_CONTENT_GIT_URL is not set. Exiting."
  exit 1
else
  if [ -d "content" ]; then
    echo "Removing existing content directory"
    rm -rf content
  fi
  echo "Cloning content from $HUGO_CONTENT_GIT_URL"
  git clone $HUGO_CONTENT_GIT_URL content
fi

if [ "$STAGE" = "DEV" ]; then
  echo "Starting hugo server in dev mode"
  hugo server -D --bind 0.0.0.0 --disableFastRender --ignoreCache
  tail -f /dev/null
elif [ "$STAGE" = "PRD" ]; then
  echo "Starting hugo server in prod mode"
  hugo server --bind 0.0.0.0
else
  echo "Invalid STAGE. Exiting."
  exit 1
fi
