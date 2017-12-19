#!/usr/bin/env bash
# First parameter:
# ##
# develop: checkout develop
#
reset_database(){
 # Refresh database from production
    echo Default settings in database
    if [[ ! -f sites/default/settings.php ]];then
    echo Site name will be ${site_name}
    drush site-install minimal -y --account-name=dev --account-pass=dev --db-url=mysql://${db_name}:${db_name}@v-swds-db01/${db_name} --site-name=TVOKids
    # Install/Run TVO enable new structure module
    drush en tvokids_enable_new_structure -y

    # Install/Run TVO perform data module
    drush en tvokids_perform_data -y

    # Rebuild Permissions
    drush eval 'node_access_rebuild();' 
    fi
    drush vset error_level 2
    drush updb -y
    drush cc views
    drush upwd dev --password="dev"
    drush cc all
    drush massimp
    drush en tvokids_prod_content -y
    return 1;
}
#
# Obtain environment
current_DIR=$(readlink -f ../.)
current_DIR=${current_DIR##*/}
environment=${current_DIR%%.*}

# Verify environment pattern
if [[ $environment != dev* ]];then
  echo "Please execute script from a DEV environment"
  exit
fi
echo 'done';
exit
site_name=environment
# give permission to  settings.php
# Delete settings.php
chmod 777 sites/default
chmod 777 sites/default/settings.php
rm -f sites/default/settings.php


# First time website setup
db_name='org_'${environment}
db_name=${db_name/x/}


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
