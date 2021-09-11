#!/usr/bin/env bash
CUDA_VERSION=${1:-"11.4"}
CUDNN_VERSION=${2:-"8.2.2.26-1"}
CUDNN_MAJOR_VERSION=${3:-"8"}
LIB_DIR_PREFIX=${4:-"x86_64"}
ARCH=${5:-""}


set -e

# Workaround for nvidia.cn repo
rm -rf /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list
apt-key adv --fetch-keys https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
echo "deb https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# Pick up some TF dependencies
echo "Running apt-get update..."
apt-get update

echo "Install CUDA version: ${CUDA_VERSION}"
apt-get install -y --no-install-recommends \
    build-essential \
    cuda-command-line-tools-${CUDA_VERSION/./-} \
    libcublas-${CUDA_VERSION/./-} \
    cuda-nvrtc-${CUDA_VERSION/./-} \
    libcufft-${CUDA_VERSION/./-} \
    libcurand-${CUDA_VERSION/./-} \
    libcusolver-${CUDA_VERSION/./-} \
    libcusparse-${CUDA_VERSION/./-} \
    libcudnn8=${CUDNN_VERSION}+cuda${CUDA_VERSION} \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libzmq3-dev \
    pkg-config \
    software-properties-common

# Install TensorRT if not building for PowerPC
# NOTE: libnvinfer uses cuda11.1 versions
# RUN [[ "${ARCH}" = "ppc64le" ]] || { apt-get update && \
#     apt-get install -y --no-install-recommends libnvinfer${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda11.1 \
#     libnvinfer-plugin${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda11.1 \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*; }

apt-mark hold libcudnn8
apt-get autoremove -y && apt-get clean -y
rm -rf /var/lib/apt/lists/*

# For CUDA profiling, TensorFlow requires CUPTI.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1
echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf && ldconfig
