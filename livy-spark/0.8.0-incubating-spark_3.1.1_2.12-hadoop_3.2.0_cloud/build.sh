#!/bin/sh

set -ex

DOCKERHUB_REPO=${DOCKERHUB_REPO:-jeromebanks}

script_path=`realpath $0`
dir_path=`dirname ${script_path}`
no_cache="--no-cache"

parent_dir_path=$(dirname ${dir_path})

repo="$DOCKERHUB_REPO/${parent_dir_path##*/}"
tag="${dir_path##*/}_TT6"

( cd ${dir_path}; docker build . ${no_cache} -t "${repo}:${tag}" )
docker push "${repo}:${tag}"
echo "Done! Enjoy..."
