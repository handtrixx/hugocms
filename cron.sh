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
  echo "Pulling theme updates from $HUGO_THEME_GIT_URL"
  cd /var/www/site/themes/theme
  git pull $HUGO_THEME_GIT_URL
  cd -
fi

# check for environment variable HUGO_CONTENT_GITURL
if [ -z "$HUGO_CONTENT_GIT_URL" ]; then
  echo "HUGO_CONTENT_GIT_URL is not set. Will use local clone."
else
  echo "Pulling content updates from $HUGO_CONTENT_GIT_URL"
  cd /var/www/site/content
  git pull $HUGO_CONTENT_GIT_URL
  cd -
fi

# switch command for $STAGE variables
cd /var/www/site/
case $STAGE in
  DEV)
    echo "Container is alive. Running in DEV mode"
    ;;
  QAS)
    echo "Container is alive. Running in QAS mode"
    echo "Rebuilding Site"
    hugo
    echo "Rebuild Complete"
    ;;
  PRD)
    echo "Container is alive. Running in PRD mode"
    echo "Rebuilding Site"
    hugo
    echo "Rebuild Complete"
    ;;
  *)
    echo "Invalid STAGE. Exiting."
    exit 1
    ;;
esac