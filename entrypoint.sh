#!/bin/bash

# check for environment variable STAGE
if [ -z "$STAGE" ]; then
  echo "STAGE is not set. Exiting."
  exit 1
fi

# check for environment variable HUGO_THEME_GIT_URL
if [ -z "$HUGO_THEME_GIT_URL" ]; then
  echo "HUGO_THEME_GIT_URL is not set. Will use local clone."
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
  echo "HUGO_CONTENT_GIT_URL is not set. Will use local clone."
else
  if [ -d "content" ]; then
    echo "Removing existing content directory"
    rm -rf content
  fi
  echo "Cloning content from $HUGO_CONTENT_GIT_URL"
  git clone $HUGO_CONTENT_GIT_URL content
fi

# switch command for $STAGE variables
case $STAGE in
  DEV)
    echo "Running in DEV mode"
    hugo server -D --bind 0.0.0.0 --disableFastRender --ignoreCache --buildDrafts --buildExpired --buildFuture --cleanDestinationDir
    
    tail -f /dev/null
    ;;
  QAS)
    echo "Running in QAS mode"
    hugo server --bind 0.0.0.0 --cleanDestinationDir --minify -e testing
    ;;
  PRD)
    echo "Running in PRD mode"
    hugo server --bind 0.0.0.0 --cleanDestinationDir --disableLiveReload --minify -e production
    ;;
  *)
    echo "Invalid STAGE. Exiting."
    exit 1
    ;;
esac
 