#!/usr/bin/env bash

set -e
path=$(dirname "$0")
true=`which true`
source $path/common.sh


echo "...Database update again so updated modules can work."
docker exec -u 0 -it ${CONTAINER_NAME}_php_apache_1 ../bin/drush updb -y

echo "...Clearing caches."
docker exec -u 0 -it ${CONTAINER_NAME}_php_apache_1 ../bin/drush cc all -y

echo "...Running Database update again so installed & updated modules can work."
docker exec -u 0 -it ${CONTAINER_NAME}_php_apache_1 ../bin/drush updb -y

echo "...Running Database update again so installed & updated modules can work."
docker exec -u 0 -it ${CONTAINER_NAME}_php_apache_1 ../bin/drush fra -y

echo "...Clearing caches one last time."
docker exec -u 0 -it ${CONTAINER_NAME}_php_apache_1 ../bin/drush cc all -y

# put back any thing we changed in the config or git will get angry with us on the next pull.
#git checkout config/default/*

echo "...Build Complete"
echo "...To install database and files run ./build/import.sh"