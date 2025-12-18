# Kubernetes Resource Allocation Summary

## 1. Overview

This document summarizes the CPU and memory resource **requests and limits**
configured for major workloads running in the Kubernetes cluster.
The purpose of this report is to:
- Provide visibility into current resource allocation
- Validate resource sizing against best practices
- Support review and evaluation of cluster capacity planning

All values below are collected from live Kubernetes workloads.

---

## 2. Resource Summary by Component

### 2.1 Argo CD

| Component        | CPU Request | Memory Request | CPU Limit | Memory Limit |
|------------------|------------:|---------------:|----------:|-------------:|
| argo-cd-server   | 64m         | 128Mi          | 128m      | 256Mi        |

**Notes**
- Argo CD server is lightly provisioned
- Resource limits are set at 2× request (acceptable for UI/API workload)

---

### 2.2 cert-manager

| Component                    | CPU Request | Memory Request | CPU Limit | Memory Limit |
|-----------------------------|------------:|---------------:|----------:|-------------:|
| cert-manager-controller     | 64m         | 128Mi          | 128m      | 256Mi        |
| cert-manager-cainjector     | 64m         | 128Mi          | 128m      | 256Mi        |
| cert-manager-webhook        | 64m         | 128Mi          | 128m      | 256Mi        |

**Notes**
- All cert-manager components use consistent sizing
- Safe defaults for small to medium clusters

---

### 2.3 Kafka

| Component          | CPU Request | Memory Request | CPU Limit | Memory Limit |
|--------------------|------------:|---------------:|----------:|-------------:|
| kafka-controller-0 | 384m        | 768Mi          | 768m      | 1536Mi       |

**Notes**
- Kafka controller requires higher memory
- Limit is set to 2× request, suitable for control-plane workload

---

### 2.4 Kubernetes System (kube-system)

| Component              | CPU Request | Memory Request | CPU Limit | Memory Limit |
|------------------------|------------:|---------------:|----------:|-------------:|
| coredns (per pod)      | 100m        | 170Mi          | –         | 170Mi        |
| cilium                 | 300m / 20m  | 300Mi / 50Mi   | –         | 50Mi         |
| do-node-agent          | 102m        | 80Mi           | –         | 300Mi        |
| csi-do-node            | –           | –              | –         | –            |

**Notes**
- Most system components rely on requests only
- Limits are intentionally omitted to avoid system instability

---

### 2.5 MongoDB Sharded Cluster

| Component                     | CPU Request | Memory Request | CPU Limit | Memory Limit |
|--------------------------------|------------:|---------------:|----------:|-------------:|
| configsvr-0                    | 192m        | 384Mi          | 384m      | 768Mi        |
| mongos                         | 192m        | 384Mi          | 384m      | 768Mi        |
| shard0-data-0                  | 384m        | 768Mi          | 768m      | 1536Mi       |

**Notes**
- MongoDB workloads are memory-intensive
- Limits are set to 2× request to allow burst under load

---

### 2.6 NGINX Ingress Controller

| Component                          | CPU Request | Memory Request | CPU Limit | Memory Limit |
|-----------------------------------|------------:|---------------:|----------:|-------------:|
| nginx-ingress-controller           | 128m        | 256Mi          | 256m      | 512Mi        |
| default-backend                    | 64m         | 128Mi          | 128m      | 256Mi        |

**Notes**
- Suitable for moderate traffic
- Can be scaled horizontally if traffic increases

---

### 2.7 Redis Cluster

| Pod               | CPU Request | Memory Request | CPU Limit | Memory Limit |
|-------------------|------------:|---------------:|----------:|-------------:|
| redis-cluster-0   | 192m        | 384Mi          | 384m      | 768Mi        |
| redis-cluster-1   | 192m        | 384Mi          | 384m      | 768Mi        |
| redis-cluster-2   | 192m        | 384Mi          | 384m      | 768Mi        |
| redis-cluster-3   | 192m        | 384Mi          | 384m      | 768Mi        |
| redis-cluster-4   | 192m        | 384Mi          | 384m      | 768Mi        |
| redis-cluster-5   | 192m        | 384Mi          | 384m      | 768Mi        |

**Notes**
- Redis cluster consists of 6 nodes
- Uniform resource allocation across all pods
- Memory limits are critical to prevent eviction

---

## 3. Overall Assessment

- ✅ Resource requests and limits are consistently defined
- ✅ Stateful workloads (Kafka, MongoDB, Redis) have higher memory allocation
- ✅ System components avoid strict limits where appropriate
- ⚠️ Future scaling may require:
  - Increasing node pool size
  - Separating system and data workloads into different node pools

---

## 4. Conclusion

The current resource allocation is **well-balanced and production-ready** for a
small to medium-sized Kubernetes cluster. The configuration follows Kubernetes
best practices and allows sufficient headroom for workload bursts while avoiding
resource starvation.

This setup is suitable for academic evaluation and real-world deployment.