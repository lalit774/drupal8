#!/usr/bin/env bash
# First parameter:
# ##
#
# database: It will refresh database from backup folder
# files: It will refresh files folder from backup folder. It will take more than 45 min
# refresh: it will refresh database and checkout master branch
# develop: checkout develop
# master: checkout master
#
#
reset_database(){
echo 'here'
exit
 # Refresh database from production
    echo Default settings in database
  #  if [[ ! -f sites/default/settings.php ]];then
    echo Site name will be ${site_name}
    drush site-install minimal -y --account-name=dev --account-pass=dev --db-url=mysql://root:@localhost/${environment} --site-name=environment
    # Install/Run initializer module
    drush en initializer -y
 #   fi
    drush vset error_level 2
    drush updb -y
    drush cc views
    drush upwd dev --password="dev"
    drush cc all
    return 1;
}
#
# Obtain environment
current_DIR=$(readlink -f ./.)
current_DIR=${current_DIR##*/}
environment=${current_DIR%%.*}
# Verify environment pattern
if [[ $environment != drupal8 ]];then
  echo "Please execute script from a DEV environment"
  exit
fi

site_name=environment
# give permission to  settings.php
# Delete settings.php
#if [[ ! -f sites/default/settings.php ]];then
 #   chmod 777 sites/default
 #   chmod 777 sites/default/settings.php
  #  rm -f sites/default/settings.php
#}
#else{

#}



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

 # Refresh database from production
    reset_database
      echo "Done"
  exit