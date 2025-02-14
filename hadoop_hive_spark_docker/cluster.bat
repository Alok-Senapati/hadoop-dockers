@echo off

IF "%1"=="install" (
  docker network create --subnet=172.20.0.0/16 hadoopnet

  rem Starting Postresql Hive metastore
  ECHO ">> Starting postgresql hive metastore ..."
  docker run -d --net hadoopnet --ip 172.20.1.4 --hostname psqlhms --name psqlhms -e POSTGRES_PASSWORD=hive -it aloksenapati/hadoop_cluster:postgresql-hms
  TIMEOUT /t 5 /nobreak > nul
  
  rem 3 nodes
  ECHO ">> Starting master and worker nodes ..."
  docker run -d --net hadoopnet --ip 172.20.1.1 -p 50070:50070 -p 50090:50090 -p 8088:8088 -p 19888:19888 -p 10000:10000 -p 9083:9083 -p 8080:8081 -p 18080:18080 --hostname nodemaster --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --name nodemaster -it aloksenapati/hadoop_cluster:hive
  docker run -d --net hadoopnet --ip 172.20.1.2 --hostname node2 --add-host nodemaster:172.20.1.1 --add-host node3:172.20.1.3 --name node2 -it aloksenapati/hadoop_cluster:spark
  docker run -d --net hadoopnet --ip 172.20.1.3 --hostname node3 --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --name node3 -it aloksenapati/hadoop_cluster:spark
  docker run -d --net hadoopnet --ip 172.20.1.5 -p 2181:2181 -p 9092:9092 -p 8080:8082--hostname edge --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name edge -it aloksenapati/hadoop_cluster:edge 
  docker run -d --net hadoopnet --ip 172.20.1.6 -p 8080:8080 --hostname nifi --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name nifi -it aloksenapati/hadoop_cluster:nifi 
  docker run -d --net hadoopnet --ip 172.20.1.7  -p 8888:8888 --hostname huenode --add-host edge:172.20.1.5 --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name hue -it aloksenapati/hadoop_cluster:hue 
  docker run -d --net hadoopnet --ip 172.20.1.8  -p 8081:8081 --hostname zeppelin --add-host edge:172.20.1.5 --add-host nodemaster:172.20.1.1 --add-host node2:172.20.1.2 --add-host node3:172.20.1.3 --add-host psqlhms:172.20.1.4 --name zeppelin -it aloksenapati/hadoop_cluster:zeppelin

  rem Format nodemaster
  ECHO ">> Formatting hdfs ..."
  docker exec -u hadoop -it nodemaster hdfs namenode -format
  call :startServices
  EXIT /B 0
)


IF "%1"=="stop" (
  call :stopServices
  EXIT /B 0
)


IF "%1"=="uninstall" (
  call :stopServices
  docker rmi aloksenapati/hadoop_cluster:hadoop aloksenapati/hadoop_cluster:spark aloksenapati/hadoop_cluster:hive aloksenapati/hadoop_cluster:postgresql-hms aloksenapati/hadoop_cluster:hue aloksenapati/hadoop_cluster:edge aloksenapati/hadoop_cluster:nifi aloksenapati/hadoop_cluster:zeppelin -f
  docker network rm hadoopnet
  docker system prune -f
  EXIT /B 0
)


IF "%1"=="start" (
  docker start psqlhms nodemaster node2 node3 edge hue nifi zeppelin
  call :startServices
  EXIT /B 0
)

IF "%1"=="pull_images" (
  docker pull -a aloksenapati/hadoop_cluster
  EXIT /B 0
)

ECHO "Usage: cluster.bat pull_images|install|start|stop|uninstall"
ECHO "                 pull_images - download all docker images"
ECHO "                 install - Prepare to run and start for first time all containers"
ECHO "                 start  - start existing containers"
ECHO "                 stop   - stop running processes"
ECHO "                 uninstall - remove all docker images"


EXIT /B 0

rem Bring the services up
:startServices
docker start nodemaster node2 node3
TIMEOUT /t 5 /nobreak > nul
ECHO ">> Starting hdfs ..."
docker exec -u hadoop -it nodemaster start-dfs.sh
TIMEOUT /t 5 /nobreak > nul
ECHO ">> Starting yarn ..."
docker exec -u hadoop -d nodemaster start-yarn.sh
TIMEOUT /t 5 /nobreak > nul
ECHO ">> Starting MR-JobHistory Server ..."
docker exec -u hadoop -d nodemaster mr-jobhistory-daemon.sh start historyserver
TIMEOUT /t 5 /nobreak > nul
ECHO ">> Starting Spark ..."
docker exec -u hadoop -d nodemaster start-master.sh
docker exec -u hadoop -d node2 start-slave.sh nodemaster:7077
docker exec -u hadoop -d node3 start-slave.sh nodemaster:7077
TIMEOUT /t 5 /nobreak > nul
ECHO ">> Starting Spark History Server ..."
docker exec -u hadoop nodemaster start-history-server.sh
TIMEOUT /t 5 /nobreak > nul
ECHO ">> Preparing hdfs for hive ..."
docker exec -u hadoop -it nodemaster hdfs dfs -mkdir -p /tmp
docker exec -u hadoop -it nodemaster hdfs dfs -mkdir -p /user/hive/warehouse
docker exec -u hadoop -it nodemaster hdfs dfs -chmod -R 777 /tmp
docker exec -u hadoop -it nodemaster hdfs dfs -chmod -R 777 /user/hive/warehouse
TIMEOUT /t 5 /nobreak > nul
ECHO ">> Starting Hive Metastore ..."
docker exec -u hadoop -d nodemaster hive --service metastore
docker exec -u hadoop -d nodemaster hive --service hiveserver2
ECHO ">> Starting Nifi Server ..."
docker exec -u hadoop -d nifi /home/hadoop/nifi/bin/nifi.sh start
ECHO ">> Starting kafka Server ..."
docker exec -u hadoop -d edge /home/hadoop/kafka/bin/zookeeper-server-start.sh -daemon  /home/hadoop/kafka/config/zookeeper.properties
docker exec -u hadoop -d edge /home/hadoop/kafka/bin/kafka-server-start.sh -daemon  /home/hadoop/kafka/config/server.properties
ECHO ">> Starting Zeppelin ..."
docker exec -u hadoop -d zeppelin /home/hadoop/zeppelin/bin/zeppelin-daemon.sh start
ECHO "Hadoop info @ nodemaster: http://172.20.1.1:8088/cluster"
ECHO "DFS Health @ nodemaster : http://172.20.1.1:50070/dfshealth"
ECHO "MR-JobHistory Server @ nodemaster : http://172.20.1.1:19888"
ECHO "Spark info @ nodemaster  : http://172.20.1.1:8080"
ECHO "Spark History Server @ nodemaster : http://172.20.1.1:18080"
ECHO "Zookeeper @ edge : http://172.20.1.5:2181"
ECHO "Kafka @ edge : http://172.20.1.5:9092"
ECHO "Nifi @ edge : http://172.20.1.5:8080/nifi & from host @ http://localhost:8080/nifi"
ECHO "Zeppelin @ zeppelin : http://172.20.1.6:8081 & from host @ http://localhost:8081"
EXIT /B 0

:stopServices
ECHO ">> Stopping Spark Master and slaves ..."
docker exec -u hadoop -d nodemaster stop-master.sh
docker exec -u hadoop -d node2 stop-slave.sh
docker exec -u hadoop -d node3 stop-slave.sh
docker exec -u hadoop -d nifi /home/hadoop/nifi/bin/nifi.sh stop
docker exec -u hadoop -d zeppelin /home/hadoop/zeppelin/bin/zeppelin-daemon.sh stop
ECHO ">> Stopping containers ..."
docker stop nodemaster node2 node3 edge hue nifi zeppelin psqlhms
EXIT /B 0
