#!/usr/bin/env bash
# First parameter:
# ##
# develop: checkout develop
#
reset_database(){
 # Refresh database from production
    echo Default settings in database
    if [ ! -f sites/default/settings.php ];then
    echo Site name will be ${site_name}
    drush si minimal -y --account-name=dev --account-pass=dev --db-url=mysql://${db_name}:${db_password}@localhost/${site_name} --site-name=site_name
    # Install/Run initializer module
    drush en initializer -y
    fi
    drush updb -y
    drush upwd dev --password="dev"
    drush cache-rebuild
    return 1;
}
#
# Obtain environment
current_DIR=$(readlink -f ./.)
current_DIR=${current_DIR##*/}
environment=${current_DIR%%.*}

# Verify environment pattern
if [ ! $environment != drupal8* ];then
  echo "Please execute script from a right project."
  exit
fi

site_name=environment
# give permission to  settings.php
# Delete settings.php
if [ -f sites/default/settings.php ];then
    chmod 777 sites/default
    chmod 777 sites/default/settings.php
    rm -f sites/default/settings.php
fi


# First time website setup
db_name='root'
db_password='nothing'

# Refresh git develop branch (or some other branch)i
if [ -z "$1" ]; then
  git checkout develop
  git pull origin develop
  site_name='develop'
else
  git checkout $1
  git pull origin $1
  site_name=$1
fi

reset_database
