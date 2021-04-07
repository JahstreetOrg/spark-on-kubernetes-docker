ARG SPARK_BASE=jeromebanks/livy-spark:0.7.0-incubating-spark_2.4.5_2.11-hadoop_3.1.0_cloud-4.9.2-test

FROM $SPARK_BASE

LABEL maintainer="Jerome Banks <jerome@tatari.tv>"

ENV BASE_IMAGE	$SPARK_BASE#$BASE_IMAGE

RUN cp $LIVY_CONF_DIR/log4j.properties.template $LIVY_CONF_DIR/log4j.properties && \
    mkdir -p $LIVY_HOME/work-dir && \
    mkdir /var/log/livy && \
    ln -s /var/log/livy $LIVY_HOME/logs

COPY conf/* $LIVY_CONF_DIR/
COPY entrypoint.sh /opt/
COPY Dockerfile /my_docker/

#  8998 - Livy Server port
# 10000 - Livy RPC Server for Jupyter integration
EXPOSE 8998 10000

WORKDIR $LIVY_HOME/work-dir

ENTRYPOINT [ "/opt/entrypoint.sh" ]
