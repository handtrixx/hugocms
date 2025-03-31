#!/bin/bash
changed=false

# Function to check for new commits and perform git pull if needed
pull_if_new_commits() {
  local repo_dir=$1
  local repo_url=$2

  cd $repo_dir
  git fetch
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse @{u})

  if [ $LOCAL != $REMOTE ]; then
    echo "New commits found. Pulling updates from $repo_url"
    git pull $repo_url
  else
    echo "No new commits found in $repo_url"
  fi
  cd -
}

# check for environment variable HUGO_THEME_GIT_URL
if [ -z "$HUGO_THEME_GIT_URL" ]; then
  echo "HUGO_THEME_GIT_URL is not set. Will use local clone."
else
  pull_if_new_commits /var/www/themes/theme $HUGO_THEME_GIT_URL
  # set changed variable to true
  changed=true
fi

# check for environment variable HUGO_CONTENT_GITURL
if [ -z "$HUGO_CONTENT_GIT_URL" ]; then
  echo "HUGO_CONTENT_GIT_URL is not set. Will use local clone."
else
  pull_if_new_commits /var/www/content $HUGO_CONTENT_GIT_URL
  # set changed variable to true
  changed=true
  
fi

  ## run a hugo build if ENVIRONMENT is production and changed is true
  
if [ "$ENVIRONMENT" == "production" ] && [ "$changed" == "true" ]; then
    echo "Running hugo build for production"
    hugo --environment $ENVIRONMENT --destination /dev/shm/nsde --baseURL $BASE_URL --cleanDestinationDir --minify
  else 
    echo "Not in production environment or nothing changed. Skipping hugo build."
  fi