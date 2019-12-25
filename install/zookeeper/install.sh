#!/bin/bash
set -euo pipefail

BASEDIR=$(dirname "$0")
echo "$BASEDIR"

ZK_HOST1=$1
ZK_HOST2=$2
ZK_HOST3=$3
MY_ID=$4

mkdir -p zookeeper
tar -xvzf $BASEDIR/apache-zookeeper-3.5.6-bin.tar.gz -C zookeeper
chmod 777 ./zookeeper/apache-zookeeper-3.5.6-bin/conf
rm ./zookeeper/apache-zookeeper-3.5.6-bin/conf/zoo.cfg || true
cat >> ./zookeeper/apache-zookeeper-3.5.6-bin/conf/zoo.cfg <<EOF
tickTime=2000
dataDir=./zookeeper-data/data
dataLogDir=./zookeeper-data/log
clientPort=2181
initLimit=5
syncLimit=2
minSessionTimeout=40000
maxSessionTimeout=80000
server.1=${ZK_HOST1}:2888:3888
server.2=${ZK_HOST2}:2888:3888
server.3=${ZK_HOST3}:2888:3888
EOF
mkdir -p ./zookeeper-data/data
chmod 777 ./zookeeper-data/data
sudo echo "${MY_ID}" > ./zookeeper-data/data/myid 
./zookeeper/apache-zookeeper-3.5.6-bin/bin/zkServer.sh stop || true
./zookeeper/apache-zookeeper-3.5.6-bin/bin/zkServer.sh start
