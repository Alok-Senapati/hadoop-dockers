FROM alok_senapati/hadoop_cluster:hive
ARG CACHEBUST=1

USER root

# get sources
RUN wget https://dlcdn.apache.org/zeppelin/zeppelin-0.10.1/zeppelin-0.10.1-bin-all.tgz -P /home/hadoop/
RUN tar -xzf /home/hadoop/zeppelin-0.10.1-bin-all.tgz -C /home/hadoop/
RUN mv /home/hadoop/zeppelin-0.10.1-bin-all /home/hadoop/zeppelin
RUN rm -rf /home/hadoop/zeppelin-0.10.1-bin-all*

RUN chown hadoop -R /home/hadoop/zeppelin


RUN echo "export ZEPPELIN_ADDR=0.0.0.0" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export ZEPPELIN_PORT=8081" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh

RUN echo "export SPARK_HOME=/home/hadoop/spark" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh

# set hadoop conf dir
RUN echo "export HADOOP_HOME=/home/hadoop/hadoop" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh

RUN echo "export HIVE_HOME=/home/hadoop/hive" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh
RUN echo "export ZEPPELIN_INTP_CLASSPATH_OVERRIDES=$HIVE_HOME/conf" >> /home/hadoop/zeppelin/conf/zeppelin-env.sh

