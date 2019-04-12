FROM ubuntu:16.04

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
    ln -s /opt/apache-maven-3.6.0 /opt/maven

ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ENV M2_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=${M2_HOME}/bin:${PATH}
