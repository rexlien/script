#!/bin/bash
which docker
if [ $? -eq 0 ]
then
    docker --version | grep "1.0"
    if [ $? -eq 0 ]
    then
        echo "docker existing"
    else
        echo "wrong version"
    fi
else
    yum install yum-utils device-mapper-persistent-data lvm2

    ### Add docker repository.
    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

    ## Install docker ce.
    yum -y update && sudo yum -y install docker-ce-18.06.2.ce

    ## Create /etc/docker directory.
    mkdir /etc/docker

    # Setup daemon.
    cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
    
    mkdir -p /etc/systemd/system/docker.service.d

    # Restart docker.
    systemctl daemon-reload
    systemctl restart docker
    systemctl enable docker.service
fi
