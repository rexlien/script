helm delete dash-board
helm del --purge dash-board
helm install stable/kubernetes-dashboard --wait --set=enableSkipLogin=true --name dash-board
export POD_NAME=$(kubectl get pods -n default -l "app=kubernetes-dashboard,release=dash-board" -o jsonpath="{.items[0].metadata.name}")
until kubectl -n default port-forward $POD_NAME 8443:8443; do
    sleep 1
done
##kubectl -n default port-forward $POD_NAME 8443:8443
