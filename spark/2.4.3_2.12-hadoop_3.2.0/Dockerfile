ARG SPARK_BASE=sasnouskikh/spark-base:2.4.3_2.12-without-hadoop
FROM $SPARK_BASE

ARG HADOOP_VERSION_ARG=3.2.0

ENV BASE_IMAGE              $SPARK_BASE#$BASE_IMAGE
ENV HADOOP_VERSION          $HADOOP_VERSION_ARG
ENV HADOOP_HOME             /opt/hadoop
ENV HADOOP_CONF_DIR         $HADOOP_HOME/conf
ENV LD_LIBRARY_PATH         $LD_LIBRARY_PATH:$HADOOP_HOME/lib/native
ENV PATH                    $PATH:$HADOOP_HOME/bin
ENV SPARK_DIST_CLASSPATH    $SPARK_CLASSPATH:$HADOOP_HOME/etc/hadoop:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/yarn:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/tools/lib/*
ENV SPARK_CLASSPATH         $SPARK_CLASSPATH:$HADOOP_HOME/etc/hadoop:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/yarn:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/tools/lib/*

### install hadoop
RUN wget -O /hadoop-${HADOOP_VERSION}.tar.gz http://www-us.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    rm -rf $HADOOP_HOME && \
    tar -xzf /hadoop-${HADOOP_VERSION}.tar.gz -C /opt/ && \
    ln -s /opt/hadoop-${HADOOP_VERSION} $HADOOP_HOME && \
    rm -f /hadoop-${HADOOP_VERSION}.tar.gz && \
    rm -rf $HADOOP_HOME/share/doc $HADOOP_HOME/etc/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/log4j.properties

# upgrade hadoop libs
RUN rm -f $HADOOP_HOME/share/hadoop/common/lib/guava-11.0.2.jar && \
    rm -f $HADOOP_HOME/share/hadoop/hdfs/lib/guava-11.0.2.jar && \
    wget -q http://central.maven.org/maven2/com/google/guava/guava/23.0/guava-23.0.jar && \
    cp -f ./guava-23.0.jar $HADOOP_HOME/share/hadoop/common/lib/ && \
    mv -f ./guava-23.0.jar $HADOOP_HOME/share/hadoop/hdfs/lib/ && \
    rm -f $HADOOP_HOME/share/hadoop/tools/lib/azure-keyvault-core-1.0.0.jar && \
    wget -q http://central.maven.org/maven2/com/microsoft/azure/azure-keyvault-core/1.1/azure-keyvault-core-1.1.jar && \
    mv -f ./azure-keyvault-core-1.1.jar $HADOOP_HOME/share/hadoop/tools/lib/ && \
    rm -f $HADOOP_HOME/share/hadoop/hdfs/lib/netty-all-*.jar && \
    rm -f $HADOOP_HOME/share/hadoop/hdfs/lib/snappy-java-*.jar && \
    rm -f $HADOOP_HOME/share/hadoop/common/lib/snappy-java-*.jar && \
    cp -f $SPARK_HOME/jars/netty-all-*.jar $HADOOP_HOME/share/hadoop/hdfs/lib/ && \
    cp -f $SPARK_HOME/jars/snappy-java-*.jar $HADOOP_HOME/share/hadoop/hdfs/lib/ && \
    cp -f $SPARK_HOME/jars/snappy-java-*.jar $HADOOP_HOME/share/hadoop/common/lib/ && \
    rm -f $HADOOP_HOME/share/hadoop/hdfs/lib/avro-1.7.7.jar && \
    rm -f $HADOOP_HOME/share/hadoop/common/lib/avro-1.7.7.jar && \
    wget -O ./avro-1.8.2.jar http://central.maven.org/maven2/org/apache/avro/avro/1.8.2/avro-1.8.2.jar && \
    cp -f ./avro-1.8.2.jar $HADOOP_HOME/share/hadoop/hdfs/lib/ && \
    mv -f ./avro-1.8.2.jar $HADOOP_HOME/share/hadoop/common/lib/ && \
    rm -f $HADOOP_HOME/share/hadoop/tools/lib/lz4-1.2.0.jar && \
    cp -f $SPARK_HOME/jars/lz4-java-1.4.0.jar $HADOOP_HOME/share/hadoop/tools/lib/

# configure hadoop classpath with additional libs
RUN { \
        echo 'export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$HADOOP_HOME/share/hadoop/tools/lib/*'; \
    } >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# upgrade spark libs and resolve conflicts
RUN cp -f $HADOOP_HOME/share/hadoop/hdfs/lib/guava-23.0.jar $SPARK_HOME/jars/ && \
    wget -O $SPARK_HOME/jars/json4s-native_2.12-3.5.3.jar http://central.maven.org/maven2/org/json4s/json4s-native_2.12/3.5.3/json4s-native_2.12-3.5.3.jar && \
    wget -O $SPARK_HOME/jars/avro-ipc-1.8.2.jar http://central.maven.org/maven2/org/apache/avro/avro-ipc/1.8.2/avro-ipc-1.8.2.jar && \
    rm -f $SPARK_HOME/jars/okhttp-3.8.1.jar && \
    wget -O $SPARK_HOME/jars/okhttp-3.11.0.jar http://central.maven.org/maven2/com/squareup/okhttp3/okhttp/3.11.0/okhttp-3.11.0.jar && \
    rm -f $SPARK_HOME/jars/okio-1.13.0.jar && \
    wget -O $SPARK_HOME/jars/okio-1.15.0.jar http://central.maven.org/maven2/com/squareup/okio/okio/1.15.0/okio-1.15.0.jar && \
    wget -O $SPARK_HOME/jars/proton-j-0.29.0.jar http://central.maven.org/maven2/org/apache/qpid/proton-j/0.29.0/proton-j-0.29.0.jar && \
    wget -O $SPARK_HOME/jars/config-1.3.3.jar http://central.maven.org/maven2/com/typesafe/config/1.3.3/config-1.3.3.jar && \
    wget -O $SPARK_HOME/jars/scala-java8-compat_2.12-0.9.0.jar http://central.maven.org/maven2/org/scala-lang/modules/scala-java8-compat_2.12/0.9.0/scala-java8-compat_2.12-0.9.0.jar && \
    wget -O $SPARK_HOME/jars/reflections-0.9.11.jar http://central.maven.org/maven2/org/reflections/reflections/0.9.11/reflections-0.9.11.jar && \
    wget -O $SPARK_HOME/jars/log4j-1.2.17.jar http://central.maven.org/maven2/log4j/log4j/1.2.17/log4j-1.2.17.jar && \
    wget -O $SPARK_HOME/jars/commons-configuration-1.6.jar http://central.maven.org/maven2/commons-configuration/commons-configuration/1.6/commons-configuration-1.6.jar && \
    wget -O $SPARK_HOME/jars/spark-avro_2.12-2.4.2.jar http://central.maven.org/maven2/org/apache/spark/spark-avro_2.12/2.4.2/spark-avro_2.12-2.4.2.jar && \
    wget -O $SPARK_HOME/jars/kryo-serializers-0.45.jar http://central.maven.org/maven2/de/javakaffee/kryo-serializers/0.45/kryo-serializers-0.45.jar

# wget -O $SPARK_HOME/jars/spark-avro_2.11-4.0.0.jar http://central.maven.org/maven2/com/databricks/spark-avro_2.11/4.0.0/spark-avro_2.11-4.0.0.jar && \

COPY Dockerfile /my_docker/