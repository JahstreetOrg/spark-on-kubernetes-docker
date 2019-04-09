#!/bin/bash

set -ex

script_path=`realpath $0`
dir_path=`dirname ${script_path}`
no_cache="--no-cache"

spark_version=2.4.1
tag="sasnouskikh/spark-base:${spark_version}-without-hadoop"

( cd ${dir_path}; docker build . ${no_cache} -t ${tag} --build-arg SPARK_VERSION_ARG="${spark_version}" )
docker push ${tag}
echo "Done! Enjoy..."
