#!/bin/sh

set -ex

DOCKERHUB_REPO=${DOCKERHUB_REPO:-sasnouskikh}

script_path=`realpath $0`
dir_path=`dirname ${script_path}`
no_cache="--no-cache"

parent_dir_path=$(dirname ${dir_path})

livy_repo="$DOCKERHUB_REPO/${parent_dir_path##*/}"
livy_spark_repo="${livy_repo}-spark"
tag="${dir_path##*/}"

livy_tag="${livy_repo}:${tag}"
livy_spark_tag="${livy_spark_repo}:${tag}"

# livy_project_dir="/home/osboxes/git/*/incubator-livy"
# ( cd ${livy_project_dir}; mvn clean package -DskipTests -ff )
# rm -f ${dir_path}/apache-livy-*-incubating-bin.zip
# cp -f ${livy_project_dir}/assembly/target/apache-livy-*-incubating-bin.zip ${dir_path}/

(
    cd ${dir_path} && \
    docker build . -f Dockerfile.livy ${no_cache} -t "${livy_tag}" && \
    docker build . -f Dockerfile.spark ${no_cache} -t "${livy_spark_tag}"
)

docker push ${livy_tag}
docker push ${livy_spark_tag}

echo "Done! Enjoy..."