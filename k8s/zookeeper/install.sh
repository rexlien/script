helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install --name common-zookeeper --set persistence.storageClass=fast-disks incubator/zookeeper