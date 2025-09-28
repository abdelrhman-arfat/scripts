# 🟢 Kubernetes (K8s) Learning Documentation

## 1️⃣ Minikube Basics

### 1.1 Check Minikube Version

```
minikube version
```

### 1.2 Start Minikube Dashboard

```
minikube dashboard
```

- Opens the Kubernetes dashboard in your browser.
- UI for monitoring pods, deployments, services, etc.

---

## 2️⃣ Minikube Cluster Management

### 2.1 Using Docker as Runtime

```
# Stop any running Minikube cluster
minikube stop

# Delete existing cluster
minikube delete

# Start Minikube with Docker driver
minikube start --driver=docker
```

### 2.2 Using CRI-O as Runtime

```
# Stop any running Minikube cluster
minikube stop

# Delete existing cluster
minikube delete

# Start Minikube with CRI-O runtime
minikube start --container-runtime=cri-o
```

---

## 3️⃣ Kubectl Basics

### 3.1 Check Kubectl Version

```
kubectl version --client
```

### 3.2 Get Cluster Resources

```
kubectl get all
kubectl get pods
kubectl get replicaset
kubectl get deployments
kubectl get services
```

### 3.3 Create a Deployment

```
kubectl create deployment <name> --image=docker.io/library/<image> --replicas=<number>
```

- Example:

```
kubectl create deployment nginx-app --image=docker.io/library/nginx:latest --replicas=3
```

### 3.4 Scale a Deployment

```
kubectl scale deployment <name> --replicas=<number>
```

### 3.5 Update Deployment Image

```
kubectl set image deployment/<name> <container>=<image>:<tag>
```

- Example:

```
kubectl set image deployment/nginx-app nginx=docker.io/library/nginx:latest
```

### 3.6 Check Rollout Status

```
kubectl rollout status deployment/<name>
```

### 3.7 Delete a Deployment

```
kubectl delete deployment <name>
```

### 3.8 Delete Pods Forcefully

```
kubectl delete pod <pod-name> --grace-period=0 --force
```

- Delete all pods:

```
kubectl delete pod --all --grace-period=0 --force
```

---

## 4️⃣ Minikube Image Management

### 4.1 Pull an Image to Minikube

```
minikube image pull <image>:<tag>
```

### 4.2 List Minikube Images

```
minikube image ls
```

### 4.3 Load Local Image into Minikube

```
minikube image load <image>:<tag>
```

---
