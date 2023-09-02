FROM alok_senapati/hadoop_cluster:hive
ARG CACHEBUST=1

USER root


# get flume sources
RUN wget https://dlcdn.apache.org/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/apache-flume-1.11.0-bin.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/apache-flume-1.11.0-bin /home/hadoop/flume
RUN rm -rf /home/hadoop/apache-flume-1.11.0-bin*
RUN chown hadoop -R /home/hadoop/flume


# get Kafka sources
RUN wget https://downloads.apache.org/kafka/3.5.1/kafka_2.12-3.5.1.tgz -P /home/hadoop/
RUN tar -xzf /home/hadoop/kafka_2.12-3.5.1.tgz -C /home/hadoop/
RUN mv /home/hadoop/kafka_2.12-3.5.1 /home/hadoop/kafka
RUN rm -rf /home/hadoop/kafka_2.12-3.5.1*
RUN chown hadoop -R /home/hadoop/kafka
ENV KAFKA_HOME=/home/hadoop/kafka
ENV PATH $KAFKA_HOME/bin:$PATH

# get sqoop sources
RUN wget http://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -P /home/hadoop/
RUN tar -xzf /home/hadoop/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -C /home/hadoop/
RUN mv /home/hadoop/sqoop-1.4.7.bin__hadoop-2.6.0 /home/hadoop/sqoop
RUN rm -rf /home/hadoop/sqoop-1.4.7*
RUN wget https://jdbc.postgresql.org/download/postgresql-42.2.9.jar -P /home/hadoop/sqoop/lib/
RUN wget https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar -P /home/hadoop/sqoop/lib/
RUN chown hadoop -R /home/hadoop/sqoop

ENV SQOOP_HOME /home/hadoop/sqoop
ENV PATH $PATH:$SQOOP_HOME/bin


CMD service ssh start && bash

