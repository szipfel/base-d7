#!/usr/bin/env bash

# make sure this script is run from build.

set -e
path=$(dirname "$0")
true=`which true`
source $path/common.sh

echo "...Installing drupal 7... waiting 30s for the database to come up."
sleep 30s #the db container won't be quite ready otherwise.
docker exec -u 0 -it ${CONTAINER_NAME}_php_apache_1 ../bin/drush site-install standard --account-name=${DRUPAL_USERNAME} --account-pass=${DRUPAL_PASSWORD} --db-url='mysql://'${DBUSER}':'${DBPASS}'@'${CONTAINER_NAME}${DBHOST}'/'${DB}'' --site-name=${PROJECT} -y

echo "Changing permissions to the files dir"
sudo chmod -R 777 web/sites/default/files;

echo "Changing permissions on settings file to 666";
sudo chmod 666 web/sites/default/settings.php;
#cat cnf/memcached.php >> web/sites/default/settings.php
echo "Changing permissions on settings file back to 644";

docker exec -u 0 -it ${CONTAINER_NAME}_php_apache_1 ../bin/drush en gpen_features -y
docker exec -u 0 -it ${CONTAINER_NAME}_php_apache_1 ../bin/drush updb -y
docker exec -u 0 -it ${CONTAINER_NAME}_php_apache_1 ../bin/drush fra -y

echo "swapping out the files folder.";
sudo rm -rf web/sites/default/files;

sudo chmod 644 web/sites/default/settings.php;

source $path/update.sh