kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f ./dashboard_create_admin.yaml
#kubectl proxy --address 0.0.0.0 --accept-hosts '.*'