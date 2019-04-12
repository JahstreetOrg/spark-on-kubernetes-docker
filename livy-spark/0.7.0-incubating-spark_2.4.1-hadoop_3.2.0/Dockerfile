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

### install livy
# download distribution or add local one
COPY --from=build /apache-livy-${LIVY_VERSION}-bin.zip /apache-livy-${LIVY_VERSION}-bin.zip
# RUN wget -O /apache-livy-${LIVY_VERSION}-bin.zip http://ftp.byfly.by/pub/apache.org/incubator/livy/${LIVY_VERSION}/apache-livy-${LIVY_VERSION}-bin.zip && \
RUN unzip /apache-livy-${LIVY_VERSION}-bin.zip -d / && \
    mv /apache-livy-${LIVY_VERSION}-bin /opt/ && \
    rm -rf $LIVY_HOME && \
    ln -s /opt/apache-livy-${LIVY_VERSION}-bin $LIVY_HOME && \
    rm -f /apache-livy-${LIVY_VERSION}-bin.zip

COPY Dockerfile /my_docker/

#  4040 - Spark UI port
#  7078 - Driver RPC port
#  7079 - Blockmanager port
#  8088 - JMX Exporter for Prometheus
# 10000 - Livy RPC Server for Jupyter integration
EXPOSE 4040 7078 7079 8088 10000
