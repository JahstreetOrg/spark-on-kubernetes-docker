### Builder Container
FROM jeromebanks/livy-builder:0.3 as build

RUN cd / && \
    git clone https://github.com/apache/spark.git --branch v3.0.1 --single-branch && \
    cd /spark && \
    dev/make-distribution.sh \
        --name hadoop-3.2.0-cloud-scala-2.12 --pip --tgz -DskipTests \
        -Phadoop-3.2 \
        -Phadoop-cloud \
        -Pkubernetes \
        -Phive && \
    cp spark-3.0.1-bin-hadoop-3.2.0-cloud-scala-2.12.tgz /

### Final Container
FROM openjdk:8-jre-slim

LABEL maintainer="Jerome Banks <jerome@tatari.tv>"

ENV BASE_IMAGE      openjdk:8-jre-slim

RUN set -ex && \
    sed -i 's/http:/https:/g' /etc/apt/sources.list && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt install -y bash tini libc6 libpam-modules krb5-user libnss3 wget bzip2 && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    rm -rf /var/cache/apt/*

ENV SPARK_VERSION   3.0.1
ENV HADOOP_VERSION  hadoop-3.2.0-cloud
ENV SCALA_VERSION   2.12

ENV SPARK_HOME      /opt/spark
ENV SPARK_CONF_DIR  $SPARK_HOME/conf
ENV SPARK_CLASSPATH $SPARK_HOME/cluster-conf

ENV PYTHONHASHSEED  0
ENV CONDA_DIR       /opt/conda
ENV SHELL           /bin/bash

ENV PATH            $PATH:$SPARK_HOME/bin:$CONDA_DIR/bin

ARG MINICONDA_VERSION=4.8.3
ARG MINICONDA_MD5=d63adf39f2c220950a063e0529d4ff74
ARG CONDA_VERSION=4.8.3
ARG PYTHON_VERSION=3.7.8

ARG spark_uid=185

### install spark
COPY --from=build /spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION}.tgz /
RUN tar -xzf /spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION}.tgz -C /opt/ && \
    ln -s /opt/spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION} $SPARK_HOME && \
    rm -f /spark-${SPARK_VERSION}-bin-${HADOOP_VERSION}-scala-${SCALA_VERSION}.tgz && \
    mkdir -p $SPARK_HOME/work-dir && \
    mkdir -p $SPARK_HOME/spark-warehouse && \
    mkdir -p $SPARK_HOME/cluster-conf

# install Conda (https://github.com/jupyter/docker-stacks/blob/6d42503c684f3de9b17ce92a6b0c952ef2d1ecd8/base-notebook/Dockerfile#L78-L101)
RUN mkdir -p $CONDA_DIR && \
    cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-py38_${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "${MINICONDA_MD5} *Miniconda3-py38_${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-py38_${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-py38_${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    conda config --system --prepend channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda config --system --set channel_priority strict && \
    if [ ! $PYTHON_VERSION = 'default' ]; then conda install --yes python=$PYTHON_VERSION; fi && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    conda install --quiet --yes conda && \
    conda install --quiet --yes pip && \
    conda install --quiet --yes numpy scipy pandas scikit-learn && \
    conda install --quiet --yes -c conda-forge pyarrow && \
    conda update --all --quiet --yes && \
    conda clean --all -f -y

COPY conf/* $SPARK_CONF_DIR/
# $SPARK_HOME/conf gets cleaned by Spark on Kubernetes internals, create and add to classpath another directory for logging and other configs
COPY conf/* $SPARK_HOME/cluster-conf/
COPY entrypoint.sh /opt/
COPY Dockerfile /my_docker/

WORKDIR $SPARK_HOME/work-dir
RUN chmod g+w /opt/spark/work-dir

ENTRYPOINT [ "/opt/entrypoint.sh" ]

# Specify the User that the actual main process will run as
USER ${spark_uid}
