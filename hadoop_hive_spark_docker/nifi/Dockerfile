FROM ubuntu
ARG CACHEBUST=1

USER root

# open port 22
EXPOSE 22

RUN apt-get update

# OpenJDK installation
RUN apt-get install -y openjdk-8-jre openjdk-8-jdk openssh-server vim unzip

# add hadoop user
RUN useradd -m -s /bin/bash hadoop

# set pubkey authentication
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/ssh_config
RUN mkdir -p /home/hadoop/.ssh
RUN echo "PubkeyAcceptedKeyTypes +ssh-dss" >> /home/hadoop/.ssh/config
RUN echo "PasswordAuthentication no" >> /home/hadoop/.ssh/config

# copy keys
ADD configs/id_rsa.pub /home/hadoop/.ssh/id_rsa.pub
ADD configs/id_rsa /home/hadoop/.ssh/id_rsa
RUN chmod 400 /home/hadoop/.ssh/id_rsa
RUN chmod 400 /home/hadoop/.ssh/id_rsa.pub
RUN cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
RUN chown hadoop -R /home/hadoop/.ssh

# get nifi sources
RUN wget https://dlcdn.apache.org/nifi/1.23.2/nifi-1.23.2-bin.zip -P /home/hadoop/
RUN unzip /home/hadoop/nifi-1.23.2-bin.zip -d /home/hadoop/
RUN mv /home/hadoop/nifi-1.23.2 /home/hadoop/nifi
RUN rm -rf /home/hadoop/nifi-1.23.2*

# set nifi-env.sh
RUN echo -e "\n" >> /home/hadoop/nifi/bin/nifi-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /home/hadoop/nifi/bin/nifi-env.sh
RUN echo "export TOOLS_JAR=${JAVA_HOME}/lib/tools.jar" >> /home/hadoop/nifi/bin/nifi-env.sh

ADD configs/nifi.properties /home/hadoop/nifi/conf/nifi.properties
RUN chown hadoop -R /home/hadoop/nifi

CMD service ssh start && bash

