### Builder Container
FROM jeromebanks/livy-builder:0.2 as build

RUN cd / && \
    git clone https://github.com/apache/spark.git --branch v2.4.5 --single-branch && \
    cd /spark && \
    dev/make-distribution.sh \
        --name hadoop-3.1.0-cloud-scala-2.11 --pip --tgz -DskipTests \
        -Phadoop-3.1 \
        -Phadoop-cloud \
        -Pkubernetes \
        -Phive && \
    cp spark-2.4.5-bin-hadoop-3.1.0-cloud-scala-2.11.tgz /

### Final Container
FROM openjdk:8-jdk-slim

LABEL maintainer="Jerome Banks <jerome@tatari.tv>"

ENV BASE_IMAGE      openjdk:8-jdk-slim

RUN set -ex && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt install -y bash tini libc6 libpam-modules libnss3 wget bzip2 && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    rm -rf /var/cache/apt/*

ENV SPARK_VERSION   2.4.5
ENV HADOOP_VERSION  hadoop-3.1.0-cloud
ENV SCALA_VERSION   2.11

ENV SPARK_HOME      /opt/spark
ENV SPARK_CONF_DIR  $SPARK_HOME/conf
ENV SPARK_CLASSPATH $SPARK_HOME/cluster-conf

ENV PYTHONHASHSEED  0
ENV CONDA_DIR       /opt/conda
ENV SHELL           /bin/bash

ENV PATH            $PATH:$SPARK_HOME/bin:$CONDA_DIR/bin

ARG MINICONDA_VERSION=4.6.14
ARG CONDA_VERSION=4.6.14

### install spark
COPY --from=build /spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION}.tgz /
RUN tar -xzf /spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION}.tgz -C /opt/ && \
    ln -s /opt/spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION} $SPARK_HOME && \
    rm -f /spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION}.tgz && \
    mkdir -p $SPARK_HOME/work-dir && \
    mkdir -p $SPARK_HOME/spark-warehouse && \
    mkdir -p $SPARK_HOME/cluster-conf

# install Conda (https://github.com/frol/docker-alpine-miniconda3/blob/master/Dockerfile)
RUN mkdir -p $CONDA_DIR && \
    cd /tmp && \
    wget -O /tmp/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh  https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    /bin/bash /tmp/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm /tmp/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda install --quiet --yes conda="${CONDA_VERSION%.*}.*" && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    conda clean -tipsy && \
    conda install numpy scipy pandas scikit-learn && \
    conda install -c conda-forge pyarrow --yes && \
    conda clean -a -y

COPY conf/* $SPARK_CONF_DIR/
# $SPARK_HOME/conf gets cleaned by Spark on Kubernetes internals, create and add to classpath another directory for logging and other configs
COPY conf/* $SPARK_HOME/cluster-conf/
COPY entrypoint.sh /opt/
COPY Dockerfile /my_docker/

WORKDIR $SPARK_HOME/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]
