FROM openjdk:8-jdk-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
    apt-get -qq upgrade -y && \
    apt-get -qq install -y git wget && \
    wget -q https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp && \
    tar xf /tmp/apache-maven-3.6.3-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.6.3 /opt/maven && \
    apt-get -qq install gnupg && \
    echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get -qq update && \
    apt-get -qq install sbt && \
    apt-get -qq install -y r-base && \
    apt install -y python python-pip && \
    apt install -y python3 python3-pip && \
    # We remove ensurepip since it adds no functionality since pip is
    # installed on the image and it just takes up 1.6MB on the image
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip setuptools

ENV M2_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=${PATH}:${M2_HOME}/bin
