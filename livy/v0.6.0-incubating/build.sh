#!/bin/bash

set -ex

script_path=`realpath $0`
dir_path=`dirname ${script_path}`
no_cache="--no-cache"

livy_version="0.6.0-incubating"
spark_base=sasnouskikh/spark:2.4.1-hadoop_3.2.0
livy_tag="sasnouskikh/livy:${livy_version}-spark_2.4.1-hadoop_3.2.0"
livy_spark_tag="sasnouskikh/spark-livy:${livy_version}-spark_2.4.1-hadoop_3.2.0"

livy_project_dir="/home/osboxes/git/rseg/incubator-livy"
( cd ${livy_project_dir}; mvn clean package -DskipTests -ff )
rm -f ${dir_path}/apache-livy-*-incubating-bin.zip
cp -f ${livy_project_dir}/assembly/target/apache-livy-*-incubating-bin.zip ${dir_path}/

(
    cd ${dir_path} && \
    docker build . -f Dockerfile.livy ${no_cache} -t ${livy_tag} \
        --build-arg SPARK_BASE="${spark_base}" \
        --build-arg LIVY_VERSION_ARG="${livy_version}" && \
    docker build . -f Dockerfile.spark ${no_cache} -t ${livy_spark_tag} \
        --build-arg SPARK_BASE="${spark_base}" \
        --build-arg LIVY_VERSION_ARG="${livy_version}"  
)

docker push ${livy_tag}
docker push ${livy_spark_tag}

echo "Done! Enjoy..."