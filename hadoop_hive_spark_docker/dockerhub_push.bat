@echo off
REM push to dockerhub

REM Hadoop
docker push alok_senapati/hadoop_cluster:hadoop

REM Spark
docker push alok_senapati/hadoop_cluster:spark

REM PostgreSQL Hive Metastore Server
docker push alok_senapati/hadoop_cluster:postgresql-hms

REM Hive
docker push alok_senapati/hadoop_cluster:hive

REM Nifi
docker push alok_senapati/hadoop_cluster:nifi

REM Edge
docker push alok_senapati/hadoop_cluster:edge

REM hue
docker push alok_senapati/hadoop_cluster:hue

REM zeppelin
docker push alok_senapati/hadoop_cluster:zeppelin
