echo "Running Prerequisites on the worker cluster in the k8s directory"

# Get the k8s kubeconfig working directory
cwd=$(pwd)/k8s

# Create a for loop to iterate over all the files in the current directory
for configfile in "$cwd"/*; do
  # Do something with the file
  echo "Working on  cluster config file name"
  echo "$configfile"

  export KUBECONFIG=$configfile

  maxnodes=2
  count=0
  for NODE in $(kubectl get no --output=jsonpath={.items..metadata.name}); do
    count=$count+1
    kubectl label nodes "$NODE" kubeslice.io/node-type=gateway
    echo "Labeled node $NODE"
    if [[ $count -eq $maxnodes ]]; then
      break
    fi
  done

  kubectl apply -f metrics-components.yaml

  #kubectl create ns istio-system
  #helm install istio-base kubeslice/istio-base -n istio-system
  #helm install istiod kubeslice/istio-discovery -n istio-system
  #kubectl create ns monitoring
  helm install prometheus kubeslice/prometheus -n monitoring --create-namespace
  #Kubectl create ns kubeslice-system
  #kubectl label --overwrite ns kubeslice-system pod-security.kubernetes.io/enforce=privileged
  #kubectl create ns boutique

done