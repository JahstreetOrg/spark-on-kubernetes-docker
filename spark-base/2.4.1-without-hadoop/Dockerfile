FROM openjdk:8-alpine

ARG SPARK_VERSION_ARG=2.4.1

ENV BASE_IMAGE      openjdk:8-alpine
ENV SPARK_VERSION   $SPARK_VERSION_ARG
ENV HADOOP_VERSION  without-hadoop

ENV SPARK_HOME      /opt/spark
ENV SPARK_CONF_DIR  $SPARK_HOME/conf
ENV PATH            $PATH:$SPARK_HOME/bin

RUN set -ex && \
    apk upgrade --no-cache && \
    apk add --no-cache bash tini libc6-compat linux-pam nss openssl wget sed curl && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd

### install spark
# download distribution or add local one
# COPY spark-${SPARK_VERSION}-bin-without-hadoop.tgz /
RUN wget -O /spark-${SPARK_VERSION}-bin-without-hadoop.tgz http://www-us.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz && \
    tar -xzf /spark-${SPARK_VERSION}-bin-without-hadoop.tgz -C /opt/ && \
    ln -s /opt/spark-${SPARK_VERSION}-bin-without-hadoop $SPARK_HOME && \
    rm -f /spark-${SPARK_VERSION}-bin-without-hadoop.tgz && \
    cp $SPARK_CONF_DIR/log4j.properties.template $SPARK_CONF_DIR/log4j.properties && \
    mkdir -p $SPARK_HOME/work-dir && \
    mkdir -p $SPARK_HOME/spark-warehouse

COPY conf/* $SPARK_CONF_DIR/
COPY entrypoint.sh /opt/
COPY Dockerfile /my_docker/

RUN chmod +x /opt/*.sh

WORKDIR $SPARK_HOME/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]