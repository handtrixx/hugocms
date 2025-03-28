#!/bin/bash

# check for environment variable HUGO_THEME_GIT_URL
if [ -z "$HUGO_THEME_GIT_URL" ]; then
  echo "HUGO_THEME_GIT_URL is not set. Will use local clone."
else
    cd /var/www
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
  cd /var/www
  if [ -d "content" ]; then
    echo "Removing existing content directory"
    rm -rf content
  fi
    echo "Cloning content from $HUGO_CONTENT_GIT_URL"
    git clone $HUGO_CONTENT_GIT_URL content
fi

# switch command for $STAGE variables
# check for environment variable STAGE
if [ -z "$DEV_URL" ]; then
  echo "DEV STAGE is not set. Exiting."
else
    echo "DEV URL is set to $DEV_URL"
    cd /var/www/dev
    hugo server --environment development --baseURL="$DEV_URL" --bind 0.0.0.0 --port 1315 --baseURL $DEV_URL --buildDrafts --buildExpired --buildFuture --cleanDestinationDir --ignoreCache --disableFastRender --disableLiveReload --watch &
fi

if [ -z "$QAS_URL" ]; then
  echo "QAS STAGE is not set. Exiting."
else
    echo "QAS URL is set to $QAS_URL"
    cd /var/www/qas
    hugo server --environment testing --baseURL="$QAS_URL" --bind 0.0.0.0 --port 1314 --baseURL $QAS_URL --buildDrafts --buildExpired --buildFuture --cleanDestinationDir --disableFastRender --disableLiveReload --minify --watch --contentDir "/var/www/content" --themesDir "/var/www/themes" &
fi

if [ -z "$PRD_URL" ]; then
  echo "PRD STAGE is not set. Exiting."
else
    echo "PRD URL is set to $PRD_URL"
    cd /var/www/prd
    hugo server --environment production --baseURL="$PRD_URL" --bind 0.0.0.0 --port 1313 --baseURL $PRD_URL --cleanDestinationDir --disableFastRender --disableLiveReload --minify --watch --renderToMemory --contentDir "/var/www/content" --themesDir "/var/www/themes" &
fi

echo "Hugo started"
tail -f /dev/null