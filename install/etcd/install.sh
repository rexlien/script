#!/bin/bash
set -euo pipefail

yum install -y etcd || true
#yum -y install -y go || true
wget https://golang.org/dl/go1.16.9.linux-amd64.tar.gz
tar -xzf go1.16.9.linux-amd64.tar.gz
mv -f go /usr/local
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH 

git clone https://github.com/rexlien/etcd.git || true
cd etcd
git checkout release-3.4
./build
mv -f ./bin/etcd /usr/bin/etcd

##yum install -y etcd

TOKEN=token-01
NAME_1=machine-1
NAME_2=machine-2
NAME_3=machine-3
HOST_NAME=$1
HOST_1=$2
HOST_2=$3
HOST_3=$4
COMPACT_MODE=$5
COMPACT_RETENTION=$6
HOST_IP=$(hostname -I | cut -d" " -f 1)
#CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380

cat > /usr/lib/systemd/system/etcd.service <<EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
EnvironmentFile=-/etc/etcd/etcd.conf
User=etcd
# set GOMAXPROCS to number of processors
ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /usr/bin/etcd"
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/etcd/etcd.conf <<EOF
#[Member]
#ETCD_CORS=""
ETCD_DATA_DIR="etcd-data"
#ETCD_WAL_DIR=""
ETCD_LISTEN_PEER_URLS="http://${HOST_IP}:2380"
ETCD_LISTEN_CLIENT_URLS="http://${HOST_IP}:2379"
#ETCD_MAX_SNAPSHOTS="5"
#ETCD_MAX_WALS="5"
ETCD_NAME=${HOST_NAME}
#ETCD_SNAPSHOT_COUNT="100000"
#ETCD_HEARTBEAT_INTERVAL="100"
#ETCD_ELECTION_TIMEOUT="1000"
#ETCD_QUOTA_BACKEND_BYTES="0"
#ETCD_MAX_REQUEST_BYTES="1572864"
#ETCD_GRPC_KEEPALIVE_MIN_TIME="5s"
#ETCD_GRPC_KEEPALIVE_INTERVAL="2h0m0s"
#ETCD_GRPC_KEEPALIVE_TIMEOUT="20s"
#
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://${HOST_IP}:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://${HOST_IP}:2379"
#ETCD_DISCOVERY=""
#ETCD_DISCOVERY_FALLBACK="proxy"
#ETCD_DISCOVERY_PROXY=""
#ETCD_DISCOVERY_SRV=""
ETCD_INITIAL_CLUSTER="${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380"
ETCD_INITIAL_CLUSTER_TOKEN=${TOKEN}
ETCD_INITIAL_CLUSTER_STATE="new"
#ETCD_STRICT_RECONFIG_CHECK="true"
#ETCD_ENABLE_V2="true"
#
#[Proxy]
#ETCD_PROXY="off"
#ETCD_PROXY_FAILURE_WAIT="5000"
#ETCD_PROXY_REFRESH_INTERVAL="30000"
#ETCD_PROXY_DIAL_TIMEOUT="1000"
#ETCD_PROXY_WRITE_TIMEOUT="5000"
#ETCD_PROXY_READ_TIMEOUT="0"
#
#[Security]
#ETCD_CERT_FILE=""
#ETCD_KEY_FILE=""
#ETCD_CLIENT_CERT_AUTH="false"
#ETCD_TRUSTED_CA_FILE=""
#ETCD_AUTO_TLS="false"
#ETCD_PEER_CERT_FILE=""
#ETCD_PEER_KEY_FILE=""
#ETCD_PEER_CLIENT_CERT_AUTH="false"
#ETCD_PEER_TRUSTED_CA_FILE=""
#ETCD_PEER_AUTO_TLS="false"
#
#[Logging]
#ETCD_DEBUG="false"
#ETCD_LOG_PACKAGE_LEVELS=""
#ETCD_LOG_OUTPUT="default"
#
#[Unsafe]
#ETCD_FORCE_NEW_CLUSTER="false"
#
#[Version]
#ETCD_VERSION="false"
ETCD_AUTO_COMPACTION_RETENTION="${COMPACT_RETENTION}"
ETCD_AUTO_COMPACTION_MODE="${COMPACT_MODE}"
#
#[Profiling]
#ETCD_ENABLE_PPROF="false"
#ETCD_METRICS="basic"
#
#[Auth]
#ETCD_AUTH_TOKEN="simple"
EOF
systemctl daemon-reload
systemctl stop etcd
systemctl enable etcd
systemctl start etcd