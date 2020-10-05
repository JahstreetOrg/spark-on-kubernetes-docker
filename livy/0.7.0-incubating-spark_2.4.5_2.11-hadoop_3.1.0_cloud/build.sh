#!/bin/sh

set -ex

DOCKERHUB_REPO=${DOCKERHUB_REPO:-sasnouskikh}

script_path=`realpath $0`
dir_path=`dirname ${script_path}`
no_cache="--no-cache"

parent_dir_path=$(dirname ${dir_path})

repo="$DOCKERHUB_REPO/${parent_dir_path##*/}"
tag="${dir_path##*/}"
image="${repo}:${tag}-4.9.2-test"

( cd ${dir_path}; docker build . ${no_cache} -t "${image}" )
docker push "${image}"
echo "Done! Enjoy..."
