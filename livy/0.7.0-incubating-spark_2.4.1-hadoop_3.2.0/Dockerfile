ARG SPARK_BASE=sasnouskikh/spark:2.4.1-hadoop_3.2.0

FROM ubuntu:16.04 as build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get -qq upgrade -y && \
    apt-get -qq install -y software-properties-common python-software-properties debconf-utils && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get -qq update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    apt-get -qq install -y oracle-java8-installer oracle-java8-set-default && \
    apt-get -qq install r-base && \
    apt-get -qq install python-pip python3-pip python-dev && \
    apt-get -qq install libkrb5-dev && \
    apt-get -qq remove python-setuptools && \
    pip2 -q install --upgrade "pip < 10.0.0" "setuptools < 36" && \
    python3 -m pip -q install --upgrade "pip < 10.0.0" "setuptools < 36" && \
    pip2 -q install codecov cloudpickle && \
    python3 -m pip -q install cloudpickle && \
    pip2 -q install -U setuptools && \
    pip2 -q install "requests >= 2.10.0" pytest flaky flake8 requests-kerberos && \
    pip3 -q install "requests >= 2.10.0" pytest flaky requests-kerberos && \
    apt-get -qq clean && \
    apt-get -qq install -y git && \
    wget https://www-us.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz -P /tmp && \
    tar xf /tmp/apache-maven-*.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.6.0 /opt/maven && \
    export JAVA_HOME=/usr/lib/jvm/java-8-oracle && \
    export M2_HOME=/opt/maven && \
    export MAVEN_HOME=/opt/maven && \
    export PATH=${M2_HOME}/bin:${PATH} && \
    git clone -b v0.6.0-incubating-kubernetes-support-dev https://github.com/jahstreet/incubator-livy.git && \
    cd incubator-livy && \
    mvn clean package -DskipTests=true && \
    cp assembly/target/apache-livy-0.7.0-incubating-SNAPSHOT-bin.zip /


FROM $SPARK_BASE

ARG LIVY_VERSION_ARG=0.7.0-incubating-SNAPSHOT

ENV BASE_IMAGE              $SPARK_BASE#$BASE_IMAGE
ENV LIVY_VERSION            $LIVY_VERSION_ARG
ENV LIVY_HOME               /opt/livy
ENV LIVY_CONF_DIR           $LIVY_HOME/conf
ENV PATH                    $LIVY_HOME/bin:${PATH}

### install livy
# download distribution or add local one
COPY --from=build /apache-livy-${LIVY_VERSION}-bin.zip /apache-livy-${LIVY_VERSION}-bin.zip
# RUN wget -O /apache-livy-${LIVY_VERSION}-bin.zip http://ftp.byfly.by/pub/apache.org/incubator/livy/${LIVY_VERSION}/apache-livy-${LIVY_VERSION}-bin.zip && \
RUN unzip /apache-livy-${LIVY_VERSION}-bin.zip -d / && \
    mv /apache-livy-${LIVY_VERSION}-bin /opt/ && \
    rm -rf $LIVY_HOME && \
    ln -s /opt/apache-livy-${LIVY_VERSION}-bin $LIVY_HOME && \
    rm -f /apache-livy-${LIVY_VERSION}-bin.zip && \
    cp $LIVY_CONF_DIR/log4j.properties.template $LIVY_CONF_DIR/log4j.properties && \
    mkdir -p $LIVY_HOME/work-dir && \
    mkdir /var/log/livy && \
    ln -s /var/log/livy $LIVY_HOME/logs

COPY conf/* $LIVY_CONF_DIR/
COPY entrypoint.sh /opt/entrypoint.sh
COPY Dockerfile /my_docker/Dockerfile

RUN chmod +x /opt/*.sh

#  8998 - Livy Server port
# 10000 - Livy RPC Server for Jupyter integration
EXPOSE 8998 10000

WORKDIR $LIVY_HOME/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]