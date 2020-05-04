#!/usr/bin/env bash

task=$1
env=$2
import=$3

## Make sure we have the parameters that we need.
RED='\033[0;31m' # Red Output
YELLOW='\033[1;33m' # Yellow Output
NC='\033[0m' # No Color

if [[ $task == '' ]]
  then
    echo -e "${RED} ERROR: ${YELLOW} You need to a build type. Available options are: build-install, build-update, deploy-install and deploy-update. See github README for more details ${NC}"
    exit;
fi

if [[ $env == '' ]]
  then
    echo -e "${RED} ERROR: ${YELLOW} You need to specify the environment. Available options are: local, dev, qa, staging ${NC}"
    exit;
fi


path=$(dirname "$0")

source $path/header.sh

#get the folder name of the git repo we're in.
CONTAINER_PREFIX="$(git rev-parse --show-toplevel)"
CONTAINER_NAME="$(basename ${CONTAINER_PREFIX//_})"
CONTAINER_NAME="$(basename ${CONTAINER_PREFIX//.})"

# make drush and drupal commands and add to PATH.
echo "... building the GPEN site, please grab a drink while you wait.";
echo "...Getting drupal and running composer-y stuff.. hang on!"
COMPOSER=`which composer`
$COMPOSER install --ignore-platform-reqs --prefer-dist

if [[ $task == 'build-install' ]]
  then
    docker-compose up -d
    echo -e "${YELLOW} NOTICE:${NC} ...Building the site from scratch. Please wait"
    source $path/install.sh
elif [[ $task == 'build-update' ]]
  then
    echo -e "${YELLOW} NOTICE:${NC} ...Updating the site. Please wait"
    source $path/update.sh
elif [[ $task == 'deploy-install' ]]
  then
    echo -e "${YELLOW} NOTICE:${NC} ...Updating the site. Please wait"
    source $path/dockerless-install.sh build-install
elif [[ $task == 'deploy-update' ]]
  then
    echo -e ${YELLOW} NOTICE:${NC} "...Updating the site. Please wait"
    source $path/dockerless-install.sh build-update
elif [[ $task == 'deploy' ]]
  then
    echo -e ${YELLOW} NOTICE:${NC} "...Updating the site. Please wait"
    source $path/artifacts.sh $env
else
  echo -e "${RED} ERROR: ${YELLOW} The only options are build-install, build-update, deploy-install or deploy-update ${NC}"
fi