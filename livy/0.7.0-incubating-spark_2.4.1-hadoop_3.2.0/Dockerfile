ARG SPARK_BASE=sasnouskikh/spark:2.4.1-hadoop_3.2.0

FROM sasnouskikh/livy-builder:0.1 as build

RUN git clone -b v0.6.0-incubating-kubernetes-support-dev https://github.com/jahstreet/incubator-livy.git && \
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