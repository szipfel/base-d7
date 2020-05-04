#!/usr/bin/env bash

# make sure this script is run from build.
process=$1

set -e
path=$(dirname "$0")
true=`which true`
source $path/common.sh
cd web
if [[ $process == 'build-install' ]]
  then

    # make sure this script is run from build.

    echo "...Installing drupal 7... waiting 30s for the database to come up."
    sleep 30s #the db container won't be quite ready otherwise.
    ../bin/drush site-install standard --account-name=${DRUPAL_USERNAME} --account-pass=${DRUPAL_PASSWORD} --db-url='mysql://'${DBUSER}':'${DBPASS}'@'${CONTAINER_NAME}${DBHOST}'/'${DB}'' --site-name=${PROJECT} -y

    echo "Changing permissions to the files dir"
    sudo chmod -R 777 web/sites/default/files;

    echo "Changing permissions on settings file to 666";
    sudo chmod 666 web/sites/default/settings.php;
    #cat cnf/memcached.php >> web/sites/default/settings.php
    echo "Changing permissions on settings file back to 644";

    ../bin/drush en gpen_features -y
    ../bin/drush updb -y
    ../bin/drush fra -y

    echo "swapping out the files folder.";
    sudo rm -rf web/sites/default/files;

    sudo chmod 644 web/sites/default/settings.php;

fi

echo "...Database update again so updated modules can work."
../bin/drush updb -y

echo "...Clearing caches."
../bin/drush cc all -y

echo "...Running Database update again so installed & updated modules can work."
../bin/drush updb -y

echo "...Running Database update again so installed & updated modules can work."
../bin/drush fra -y

echo "...Clearing caches one last time."
../bin/drush cc all -y

# put back any thing we changed in the config or git will get angry with us on the next pull.
#git checkout config/default/*

echo "...Build Complete"
echo "...To install database and files run ./build/import.sh"
