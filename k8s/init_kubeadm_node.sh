USER='$1'
MASTER='$2'
NODE='$3'

rm -rf tmp.xln
rsh -l {$USER} ${MASTER} 'sudo kubeadm create token --print-join-command' > tmp.xln
bash -c 'rsh -l {$USER} ${NODE} $(cat tmp.xln)'