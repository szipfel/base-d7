#!/usr/bin/env bash

docker_path=/var/www
source setup.conf

set -e
path=$(dirname "$0")
base=$(cd $path/.. && pwd)

drush="$base/bin/drush $drush_flags -y -r $base/web"

# Confirm our working directory
if [[ ! -d "$base/web" ]]; then
  mkdir $base/
fi

# Then push it to memory
pushd $base/web

# Go to base directory
cd $base
