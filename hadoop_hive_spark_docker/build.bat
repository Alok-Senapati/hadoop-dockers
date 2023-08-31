@echo off
REM Construccion de los Contendores Docker

REM Hadoop build
docker build -f ./hadoop/Dockerfile . -t alok_senapati/hadoop_cluster:hadoop

REM Spark
docker build -f ./spark/Dockerfile . -t alok_senapati/hadoop_cluster:spark

REM PostgreSQL Hive Metastore Server
docker build -f ./postgresql-hms/Dockerfile . -t alok_senapati/hadoop_cluster:postgresql-hms

REM Hive
docker build -f ./hive/Dockerfile . -t alok_senapati/hadoop_cluster:hive

REM Nifi
docker build -f ./nifi/Dockerfile . -t alok_senapati/hadoop_cluster:nifi

REM Edge
docker build -f ./edge/Dockerfile . -t alok_senapati/hadoop_cluster:edge

REM hue
docker build -f ./hue/Dockerfile . -t alok_senapati/hadoop_cluster:hue

REM zeppelin
docker build -f ./zeppelin/Dockerfile . -t alok_senapati/hadoop_cluster:zeppelin
