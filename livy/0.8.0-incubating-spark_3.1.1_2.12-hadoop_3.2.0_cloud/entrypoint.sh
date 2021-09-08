#!/bin/bash

#Apache Livy container is fully customizable through environment variables.
#On startup livy entrypoint reads environment variables and write its values to the corresponding configs:
#- livy.conf: env format `LIVY_LIVY_<config_key_mask>=<config_value>`
#- spark-defaults.conf: env format `LIVY_SPARK_<config_key_mask>=<config_value>`
#- livy-client.conf: env format `LIVY_CLIENT_<config_key_mask>=<config_value>`
#
#Config key mask rules:
#1) KEY_MASK_WITH0DASH_WITH1UPPERCASE -> toLowerCase : key_mask_with0dash_with1uppercase
#2) key_mask_with0dash_with1uppercase -> replaceUnderscoresToDots : key.mask.with0dash.with1uppercase
#3) key.mask.with0dash.with1uppercase -> replaceZeroesToDashes : key.mask.with-dash.with1uppercase
#4) key.mask.with-dash.with1uppercase -> triggerUppercasingMarkedByOnes : key.mask.with-dash.withUppercase
#
#Examples:
#- livy.conf: LIVY_LIVY_SERVER_SESSION_MAX0CREATION -> livy.server.session.max-creation
#- spark-defaults.conf: LIVY_SPARK_EVENT1LOG_DIR -> spark.eventLog.dir
#- livy-client.conf: LIVY_CLIENT_RSC_RPC_SERVER_ADDRESS -> livy.rsc.rpc.server.address

set -eu

echo "Ahoy, Livy !!!"

: "${LIVY_CONF_DIR:?Variable not set or empty}"
: "${SPARK_CONF_DIR:?Variable not set or empty}"

LIVY_CONF_FILE=${LIVY_CONF_DIR}/livy.conf
LIVY_CLIENT_CONF_FILE=${LIVY_CONF_DIR}/livy-client.conf
SPARK_DEFAULTS_CONF_FILE=${SPARK_CONF_DIR}/spark-defaults.conf

echo "" >> ${LIVY_CONF_FILE}
echo "# Config from envs" >> ${LIVY_CONF_FILE}
for env in `env | sort | grep ^LIVY_LIVY_ | sed 's/=.*//'`; do
    key=`echo ${env,,} | sed 's/^livy_//' | sed "s/_/./g" | sed 's/1\s*./\U&\E/g' | sed 's/0/-/g' | sed 's/1//g'`
    sed -i "/^$key /d" ${LIVY_CONF_FILE}
    echo "$key ${!env}" >> ${LIVY_CONF_FILE}
done

echo "" >> ${LIVY_CLIENT_CONF_FILE}
echo "# Config from envs" >> ${LIVY_CLIENT_CONF_FILE}
for env in `env | sort | grep ^LIVY_CLIENT_ | sed 's/=.*//'`; do
    key=`echo ${env,,} | sed 's/^livy_client_/livy_/' | sed "s/_/./g" | sed 's/1\s*./\U&\E/g' | sed 's/0/-/g' | sed 's/1//g'`
    sed -i "/^$key /d" ${LIVY_CLIENT_CONF_FILE}
    echo "$key ${!env}" >> ${LIVY_CLIENT_CONF_FILE}
done

echo "" >> ${SPARK_DEFAULTS_CONF_FILE}
echo "# Config from envs" >> ${SPARK_DEFAULTS_CONF_FILE}
for env in `env | sort | grep ^LIVY_SPARK_ | sed 's/=.*//'`; do
    key=`echo ${env,,} | sed 's/^livy_//' | sed "s/_/./g" | sed 's/1\s*./\U&\E/g' | sed 's/0/-/g' | sed 's/1//g'`
    sed -i "/^$key /d" ${SPARK_DEFAULTS_CONF_FILE}
    echo "$key ${!env}" >> ${SPARK_DEFAULTS_CONF_FILE}
done

readConfigs () {
  sourceDir=$1
  destFile=$2
  echo "" >> ${destFile}
  echo "# Config mounted from ${sourceDir}" >> ${destFile}
  if [ -d "${sourceDir}" ]; then
    for key in $(ls ${sourceDir}); do
      sed -i "/^$key /d" ${destFile}
      echo "$key $(cat ${sourceDir}/${key})" >> ${destFile}
    done
  fi
}

LIVY_CONFIG_MOUNT_DIR=${LIVY_CONFIG_MOUNT_DIR:-/etc/config}
LIVY_SECRET_MOUNT_DIR=${LIVY_SECRET_MOUNT_DIR:-/etc/secret}

for root in "${LIVY_CONFIG_MOUNT_DIR}" "${LIVY_SECRET_MOUNT_DIR}"; do
  if [ -d "${root}" ]; then
    readConfigs "${root}/livy.conf" "${LIVY_CONF_FILE}"
    readConfigs "${root}/livy-client.conf" "${LIVY_CLIENT_CONF_FILE}"
    readConfigs "${root}/spark-defaults.conf" "${SPARK_DEFAULTS_CONF_FILE}"
  fi
done

exec livy-server
