FROM openjdk:8-jdk-slim

ARG SPARK_VERSION_ARG=2.4.5

ENV BASE_IMAGE      openjdk:8-jdk-slim
ENV SPARK_VERSION   $SPARK_VERSION_ARG
ENV HADOOP_VERSION  hadoop-3.1-cloud
ENV SCALA_VERSION   2.11

ENV SPARK_HOME      /opt/spark
ENV SPARK_CONF_DIR  $SPARK_HOME/conf
ENV PATH            $PATH:$SPARK_HOME/bin

# ENV PYTHONPATH ${SPARK_HOME}/python/lib/pyspark.zip:${SPARK_HOME}/python/lib/py4j-*.zip

RUN set -ex && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt install -y bash tini libc6 libpam-modules libnss3 && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    rm -rf /var/cache/apt/*

### install spark
# git checkout 2.4.5
# dev/make-distribution.sh --name hadoop-3.1-cloud-scala-2.11 --pip --tgz -Phadoop-3.1 -Phadoop-cloud -Pkubernetes -DskipTests
COPY bin/spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION}.tgz /
RUN tar -xzf /spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION}.tgz -C /opt/ && \
    ln -s /opt/spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION} $SPARK_HOME && \
    rm -f /spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION}.tgz && \
    mkdir -p $SPARK_HOME/work-dir && \
    mkdir -p $SPARK_HOME/spark-warehouse

# RUN mkdir ${SPARK_HOME}/python
# RUN apt install -y python python-pip && \
#     apt install -y python3 python3-pip && \
#     rm -r /usr/lib/python*/ensurepip && \
#     pip install --upgrade pip setuptools && \
#     rm -r /root/.cache && rm -rf /var/cache/apt/*

COPY conf/* $SPARK_CONF_DIR/
COPY entrypoint.sh /opt/
COPY Dockerfile /my_docker/

WORKDIR $SPARK_HOME/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]