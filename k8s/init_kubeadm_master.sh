
kubeadm init --kubernetes-version 1.14.0 --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

wget -O - https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml > kube-flannel_org.yml
kubectl apply -f kube-flannel_org.yml
#kubeadm token create --ttl 24m 9xg4we.1s5anm2dr74p41n6
