FROM alok_senapati/hadoop_cluster:hadoop
ARG CACHEBUST=1

USER root

# installing python for pyspark
# change python version as per your requirement
RUN apt-get update
RUN apt-get install -y python3
RUN ln -s /usr/bin/python3 /usr/bin/python 

# get sources
RUN wget https://dlcdn.apache.org/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz -P /home/hadoop/
RUN tar -xzf /home/hadoop/spark-3.4.1-bin-hadoop3.tgz -C /home/hadoop/
RUN mv /home/hadoop/spark-3.4.1-bin-hadoop3 /home/hadoop/spark
RUN rm /home/hadoop/spark-3.4.1-bin-hadoop3.tgz

RUN mkdir /home/hadoop/spark/logs
RUN chown hadoop -R /home/hadoop/spark/logs

# set environment variables
ENV SCALA_HOME /usr/share/scala
ENV SPARK_HOME /home/hadoop/spark
ENV SPARK_LOG_DIR /home/hadoop/spark/logs
# ENV SPARK_DIST_CLASSPATH $(hadoop classpath) does not work
RUN export SPARK_DIST_CLASSPATH=$(hadoop classpath)
ENV PATH $SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
RUN mv /home/hadoop/spark/conf/spark-env.sh.template /home/hadoop/spark/conf/spark-env.sh
RUN echo "export SPARK_DIST_CLASSPATH=$(hadoop classpath)" >> /home/hadoop/spark/conf/spark-env.sh
RUN echo "export SPARK_LOG_DIR=/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-env.sh
RUN mv /home/hadoop/spark/conf/spark-defaults.conf.template /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.eventLog.dir file:/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-defaults.conf
RUN echo "spark.history.fs.logDirectory file:/home/hadoop/spark/logs" >> /home/hadoop/spark/conf/spark-defaults.conf
ADD configs/workers /home/hadoop/spark/conf/slaves
RUN chown hadoop -R /home/hadoop/spark
