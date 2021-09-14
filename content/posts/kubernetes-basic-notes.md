---
title: "Kubernetes Basic Notes"
date: 2020-11-07T00:49:55-06:00
categories: ["devops"]
---
### Kubectl Installation
```bash
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
echo $PATH
sudo mv kubectl /usr/local/bin/
```

### Minikube Installation
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
minikube start
minikube status
```

### Kubectl Commands

#### CRUD Commands
```bash
kubectl create deployment [name]
kubectl edit deployment [name]
kubectl delete deployment [name]
```

#### Status of different K8s components
```bash
kubectl get `nodes | pods | services | replicasets | deployments`
```

#### Debugging pods
```bash
Kubectl logs [pod name]
kubectl exec -it containername -- bin/bash
```

### Applying YAML files
```bash
kubectl apply -f some-deployment.yaml
kubectl apply -f some-service.yaml
kubectl apply -f some-secret.yaml
kubectl describe service some-service
kubectl get pods -o wide
kubectl get deployments -o yaml
kubectl get secrets
kubectl delete -f some-deployment.yaml
kubectl delete -f some-service.yaml
kubectl delete -f some-secret.yaml
```
[Single Node Deployment Example](https://github.com/CrazyOptimist/kubernetes-mongo-express)  

### Creating secrets
```bash
echo -n 'username' | base64
echo -n 'yourpassword' | base64
```

### Namespaces
```bash
kubectl get namespace
kubectl get ns
kubectl cluster-info
kubectl get configmap -n default
kubectl get configmap -n some-namespace
kubectl config set-context --current --namespace=NAMESPACE_NAME
```

### Ingress
```bash
minikube addons enable ingress
minikube dashboard
```

{{< gist dockerlead 18696732e8ecb1a97772911e9a0d4637 >}}

### Helms
```bash
helm install --values=my-values.yaml <chartname>
kubectl exec -it nginx -c sidecar -- /bin/sh
curl localhost
kubectl logs nginx -c nginx-container
```
