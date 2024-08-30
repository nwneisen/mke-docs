---
title: NVIDIA GPU Workloads
weight: 6
---

Mirantis Kubernetes Engine (MKE) supports running workloads on NVIDIA GPU nodes.
Current support is limited to NVIDIA GPUs. MKE uses the NVIDIA GPU Operator
to manage GPU resources on the cluster.

To enable GPU support, MKE installs the NVIDIA GPU Operator on your cluster.

## Prerequisites

Before you can enable NVIDIA GPU support in MKE, you must perform the following on each GPU enabled node manually:

- Install the device [driver for your GPU](https://www.nvidia.com/en-us/drivers/)
- Install the [NVIDIA GPU toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

### Create the containerd config file

Create the containerd config file `/etc/k0s/containerd.d/nvidia.toml` with the following content. The folder structure will not exist yet and will need to be created.

```toml
version = 2
[plugins]

  [plugins."io.containerd.grpc.v1.cri"]

    [plugins."io.containerd.grpc.v1.cri".containerd]

      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]

        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
          privileged_without_host_devices = false
          runtime_engine = ""
          runtime_root = ""
          runtime_type = "io.containerd.runc.v2"

          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.options]
            BinaryName = "/usr/bin/nvidia-container-runtime"

```

## Configuration

NVIDIA GPU support is disabled by default. To enable NVIDIA GPU support, configure
the `nvidiaGPU` section of the MKE configuration file under `devicePlugins`:

```yaml
devicePlugins:
  nvidiaGPU:
    enabled: true
```

## Running GPU Workloads

Run a simple GPU workload that reports detected NVIDIA GPU devices:

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
spec:
  restartPolicy: Never
  containers:
    - name: cuda-container
      image: nvcr.io/nvidia/cloud-native/gpu-operator-validator:v22.9.0
      resources:
        limits:
          nvidia.com/gpu: 1 # requesting 1 GPU
  tolerations:
  - key: nvidia.com/gpu
    operator: Exists
    effect: NoSchedule
EOF
```

Verify that the pod completed successfully:

```bash
kubectl get pods | grep "gpu-pod"
```

Example output:

```bash
NAME                        READY   STATUS    RESTARTS   AGE
gpu-pod                     0/1     Completed 0          7m56s
```

## Upgrading

To upgrade an MKE 3 cluster with GPU enabled,
ensure you complete the [GPU prerequisites](/docs/operations/gpu/#prerequisites) before
starting the upgrade process. Failing to do so will result in the upgrade process detecting
the GPU configuration in MKE 3 and incorrectly transferring it to MKE 4.
