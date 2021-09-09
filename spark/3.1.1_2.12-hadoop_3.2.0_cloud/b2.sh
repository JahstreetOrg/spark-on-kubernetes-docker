#!/bin/sh

set -ex

DOCKERHUB_REPO=${DOCKERHUB_REPO:-jeromebanks}

script_path=`realpath $0`
dir_path=`dirname ${script_path}`
no_cache="--no-cache"

parent_dir_path=$(dirname ${dir_path})

repo="$DOCKERHUB_REPO/${parent_dir_path##*/}"
tag="${dir_path##*/}_TT6"

### Download aws-iam-authenticator
#curl -o ./aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator
#chmod +x ./aws-iam-authenticator

( cd ${dir_path}; docker build . -f ./Dock2 ${no_cache} -t "${repo}:${tag}" )
docker push "${repo}:${tag}"
echo "Done! Enjoy..."
