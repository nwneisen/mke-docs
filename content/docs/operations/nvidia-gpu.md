---
title: NVIDIA GPU Workloads
weight: 6
---

Mirantis Kubernetes Engine (MKE) supports running workloads on NVIDIA GPU nodes.
Current support is limited to NVIDIA GPUs. MKE uses the NVIDIA GPU Operator
to manage GPU resources on the cluster.

To enable GPU support, MKE installs the NVIDIA GPU Operator on your cluster.

## Prerequisites

Before you can enable NVIDIA GPU support in MKE, you must install the [NVIDIA GPU
toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
on each GPU enabled node in your cluster.

## Configuration

NVIDIA GPU support is disabled by default. To enable NVIDIA GPU support, configure
the `nvidiaGPU` section of the MKE configuration file under `devicePlugins`:

```yaml
devicePlugins:
  nvidiaGPU:
    enabled: true
```

Configuration enables MKE to install the NVIDIA GPU Operator on your cluster.

## Running GPU Workloads

Run a simple GPU workload that reports detected NVIDIA GPU devices:

```yaml
kubectl apply -f- <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    run: gpu-test
  name: gpu-test
spec:
  replicas: 1
  selector:
    matchLabels:
      run: gpu-test
  template:
    metadata:
      labels:
        run: gpu-test
    spec:
      containers:
      - command:
        - sh
        - -c
        - "deviceQuery && sleep infinity"
        image: kshatrix/gpu-example:cuda-10.2
        name: gpu-test
        resources:
          limits:
            nvidia.com/gpu: "1"
EOF
```

Verify that the deployment is in a running state:

```bash
kubectl get pods | grep "gpu-test"
```

Example output:

```bash
NAME                        READY   STATUS    RESTARTS   AGE
gpu-test-747d746885-hpv74   1/1     Running   0          14m
```

Review the logs of the `gpu-test` pod. `Result = PASS` indicates a successful
detection of the NVIDIA GPU device.

```bash
kubectl logs gpu-test-747d746885-hpv74
```

Example output:

```bash
deviceQuery Starting...

CUDA Device Query (Runtime API) version (CUDART static linking)

Detected 1 CUDA Capable device(s)

Device 0: "Tesla V100-SXM2-16GB"
...

deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 10.2, CUDA Runtime Version = 10.2, NumDevs = 1
Result = PASS
```

## Upgrading

To upgrade an MKE 3 cluster with GPU enabled, make sure that you complete the [GPU prerequisites](/docs/operations/gpu/#prerequisites) before you start the upgrade process. Failing to do this will cause the upgrade process to detect the GPU configuration in MKE 3 and incorrectly transfer it to MKE 4.
