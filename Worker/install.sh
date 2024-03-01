helm repo add kubeslice https://kubeslice.aveshalabs.io/repository/kubeslice-helm-ent-prod/ 
helm repo update 
helm search repo kubeslice 

echo "enter the controller cluster config file:"
read configfile
#--- Install Controller —
export KUBECONFIG=$configfile

kubectl cluster-info

echo "Take the time to enter k8s control plane url into the values file - endpoint field"
read continue

#--Create values.yaml file with endpoint and token/username
echo "installing kubeslice controller -----------"
helm install kubeslice-controller kubeslice/kubeslice-controller -f values.yaml --namespace kubeslice-controller --create-namespace

echo "installing kubeslice Manager UI -----------"
#--create-namespace, Create Kubeslice-manager.yaml files with token and username
helm install kubeslice-ui kubeslice/kubeslice-ui -f kubeslice-manager.yaml -n kubeslice-controller
kubectl get pods -n kubernetes-dashboard
echo "Kubeslice https endpoint IP address -----------"
kubectl get svc -n kubeslice-controller | grep ui-proxy

echo "Wait till the services come up"
read movefwd

echo "Creating project -----------"
kubectl apply -f project.yaml -n kubeslice-controller 
kubectl get project -n kubeslice-controller

echo "Wait till the services come up"
read movefwd

echo "Customer login credentials -----------"
kubectl describe secrets kubeslice-rbac-rw-ui -n kubeslice-avesha