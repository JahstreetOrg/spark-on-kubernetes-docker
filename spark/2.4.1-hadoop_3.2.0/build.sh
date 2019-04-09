#!/bin/bash

set -ex

script_path=`realpath $0`
dir_path=`dirname ${script_path}`
no_cache="--no-cache"

spark_base=sasnouskikh/spark-base:2.4.1-without-hadoop
hadoop_version=3.2.0
tag="sasnouskikh/spark:2.4.1-hadoop_${hadoop_version}"

(
	cd ${dir_path}; docker build . ${no_cache} -t ${tag} \
		--build-arg SPARK_BASE="${spark_base}" \
		--build-arg HADOOP_VERSION_ARG="${hadoop_version}"
)

docker push ${tag}
echo "Done! Enjoy..."
