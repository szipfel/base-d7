#!/usr/bin/env bash
branch_name=$1
echo "...Createing new deploy branch \n";
echo "deploy-"$branch_name;

git checkout -b "deploy-"$branch_name;
composer install
rm -rf bin
rm -rf docker
rm docker-compose.yml
rm setup.conf
rm -rf drush

echo "...Pushing deploy-"$branch_name"to repository";
git push github "deploy-"$branch_name;