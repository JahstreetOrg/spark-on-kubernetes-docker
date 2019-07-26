ARG BASE_CONTAINER=openjdk:8-alpine

FROM $BASE_CONTAINER

ARG SPARK_VERSION_ARG=2.4.3

LABEL maintainer="Aliaksandr Sasnouskikh <jaahstreetlove@gmail.com>"

ENV BASE_IMAGE      $BASE_CONTAINER

ENV SPARK_VERSION   $SPARK_VERSION_ARG
ENV HADOOP_VERSION  without-hadoop

ENV SPARK_HOME      /opt/spark
ENV SPARK_CONF_DIR  $SPARK_HOME/conf

ENV SPARK_CLASSPATH $SPARK_HOME/cluster-conf

ENV PATH            $PATH:$SPARK_HOME/bin:$CONDA_DIR/bin

ENV PYTHONHASHSEED  0
ENV CONDA_DIR       /opt/conda
ENV SHELL           /bin/bash
ENV LC_ALL          en_US.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

ARG MINICONDA_VERSION=4.6.14
ARG CONDA_VERSION=4.6.14

RUN set -ex && \
    apk upgrade --no-cache && \
    apk --update add --no-cache bash tini libstdc++ glib linux-pam krb5 krb5-libs nss openssl libressl-dev wget sed curl \
                                bzip2 unzip libxext libxrender procps coreutils ca-certificates && \
    # https://github.com/frol/docker-alpine-glibc/blob/master/Dockerfile
    curl "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk" -o glibc.apk && \
    apk add glibc.apk && \
    curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-bin-2.29-r0.apk" -o glibc-bin.apk && \
    apk add glibc-bin.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib && \
    rm -rf glibc*apk /var/cache/apk/* && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd

# install spark
RUN wget -O /spark-${SPARK_VERSION}-bin-without-hadoop.tgz https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz && \
    tar -xzf /spark-${SPARK_VERSION}-bin-without-hadoop.tgz -C /opt/ && \
    ln -s /opt/spark-${SPARK_VERSION}-bin-without-hadoop $SPARK_HOME && \
    rm -f /spark-${SPARK_VERSION}-bin-without-hadoop.tgz && \
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
    conda clean -tipsy

# Install python packages
RUN conda install numpy scipy pandas scikit-learn
RUN conda install -c conda-forge pyarrow --yes
RUN conda clean -a -y

COPY conf/* $SPARK_CONF_DIR/
# $SPARK_HOME/conf gets cleaned by Spark on Kubernetes internals, create and add to classpath another directory for logging and other configs
COPY conf/log4j.properties $SPARK_HOME/cluster-conf/
COPY entrypoint.sh /opt/
COPY Dockerfile /my_docker/

WORKDIR $SPARK_HOME/work-dir

ENTRYPOINT [ "/opt/entrypoint.sh" ]
