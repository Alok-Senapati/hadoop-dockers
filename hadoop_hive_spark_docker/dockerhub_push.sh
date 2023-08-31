#!/bin/bash

# push to dockerhub

# Hadoop
docker push alok_senapati/hadoop_cluster:hadoop

# Spark
docker push alok_senapati/hadoop_cluster:spark

# PostgreSQL Hive Metastore Server
docker push alok_senapati/hadoop_cluster:postgresql-hms

# Hive
docker push alok_senapati/hadoop_cluster:hive

# Nifi
docker push alok_senapati/hadoop_cluster:nifi

# Edge
docker push alok_senapati/hadoop_cluster:edge

# hue
docker push alok_senapati/hadoop_cluster:hue

# zeppelin
docker push alok_senapati/hadoop_cluster:zeppelin
