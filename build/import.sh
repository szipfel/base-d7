#!/usr/bin/env bash

#get the folder name of the git repo we're in.
CONTAINER_PREFIX="$(git rev-parse --show-toplevel)"
CONTAINER_NAME="$(basename ${CONTAINER_PREFIX//_})"

echo "Importing database..."
#docker exec -i ${CONTAINER_NAME}_php_apache_1 gunzip ../files/gpen.sql.gz
docker exec -i ${CONTAINER_NAME}_php_apache_1 ../bin/drush sqlc < files/GPEN.sql
