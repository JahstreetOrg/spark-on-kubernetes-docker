ARG SPARK_BASE=sasnouskikh/spark:2.4.3_2.12-hadoop_3.2.0

FROM sasnouskikh/livy-builder:0.1 as build

ENV GITHUB_REPO     jahstreet/incubator-livy
ENV GITHUB_BRANCH   v0.6.0-incubating-kubernetes-support-2.12

RUN git clone -b ${GITHUB_BRANCH} https://github.com/${GITHUB_REPO}.git && \
    cd incubator-livy && \
    mvn clean package -DskipTests=true && \
    cp assembly/target/apache-livy-0.7.0-incubating-SNAPSHOT-bin.zip /


FROM $SPARK_BASE

ARG LIVY_VERSION_ARG=0.7.0-incubating-SNAPSHOT

ENV BASE_IMAGE              $SPARK_BASE#$BASE_IMAGE
ENV LIVY_VERSION            $LIVY_VERSION_ARG
ENV LIVY_HOME               /opt/livy

### install livy
# RUN wget -O /apache-livy-${LIVY_VERSION}-bin.zip http://ftp.byfly.by/pub/apache.org/incubator/livy/${LIVY_VERSION}/apache-livy-${LIVY_VERSION}-bin.zip && \

COPY --from=build /apache-livy-${LIVY_VERSION}-bin.zip /apache-livy-${LIVY_VERSION}-bin.zip
RUN unzip /apache-livy-${LIVY_VERSION}-bin.zip -d / && \
    mv /apache-livy-${LIVY_VERSION}-bin /opt/ && \
    rm -rf $LIVY_HOME && \
    ln -s /opt/apache-livy-${LIVY_VERSION}-bin $LIVY_HOME && \
    rm -f /apache-livy-${LIVY_VERSION}-bin.zip

ADD http://central.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.11.0/jmx_prometheus_javaagent-0.11.0.jar /opt/spark/jars/jmx_prometheus_javaagent-0.11.0.jar

# No Scala 2.12 version of spark-metrics yet
#RUN wget -O /opt/spark/jars/spark-metrics_2.11-2.3-2.0.4.jar https://github.com/banzaicloud/spark-metrics/raw/master/maven-repo/releases/com/banzaicloud/spark-metrics_2.11/2.3-2.0.4/spark-metrics_2.11-2.3-2.0.4.jar && \
#    wget -O /opt/spark/jars/simpleclient-0.6.0.jar http://central.maven.org/maven2/io/prometheus/simpleclient/0.6.0/simpleclient-0.6.0.jar && \
#    wget -O /opt/spark/jars/simpleclient_dropwizard-0.6.0.jar http://central.maven.org/maven2/io/prometheus/simpleclient_dropwizard/0.6.0/simpleclient_dropwizard-0.6.0.jar && \
#    wget -O /opt/spark/jars/simpleclient_pushgateway-0.6.0.jar http://central.maven.org/maven2/io/prometheus/simpleclient_pushgateway/0.6.0/simpleclient_pushgateway-0.6.0.jar && \
#    wget -O /opt/spark/jars/collector-0.11.0.jar http://central.maven.org/maven2/io/prometheus/jmx/collector/0.11.0/collector-0.11.0.jar

COPY Dockerfile /my_docker/

#  4040 - Spark UI port
#  7078 - Driver RPC port
#  7079 - Blockmanager port
#  8088 - JMX Exporter for Prometheus
# 10000 - Livy RPC Server for Jupyter integration
EXPOSE 4040 7078 7079 8088 10000
