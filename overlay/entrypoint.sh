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
# switch $STAGE variable
echo "STAGE is set to $ENVIRONMENT"
echo "URL is set to $BASE_URL"
case "$ENVIRONMENT" in
  development)
    hugo server --environment $ENVIRONMENT --bind 0.0.0.0 --baseURL $BASE_URL --buildDrafts --buildExpired --buildFuture --cleanDestinationDir --ignoreCache --disableFastRender --disableLiveReload --watch &
    ;;
  testing)
    hugo server --environment $ENVIRONMENT --bind 0.0.0.0 --baseURL $BASE_URL --buildDrafts --buildExpired --buildFuture --cleanDestinationDir --disableFastRender --disableLiveReload --minify --watch &
    ;;
  production)
    hugo server --environment $ENVIRONMENT --bind 0.0.0.0 --baseURL $BASE_URL --cleanDestinationDir --disableFastRender --disableLiveReload --minify --watch --renderToMemory &
    ;;
  *)
    echo "No valid stage set. Exiting."
    exit 1
    ;;
esac

echo "Hugo started"
tail -f /dev/null