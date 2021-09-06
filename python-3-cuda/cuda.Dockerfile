ARG UBUNTU_VERSION=20.04

ARG ARCH=
ARG CUDA=11.4
FROM nvidia/cuda${ARCH:+-$ARCH}:${CUDA}.1-base-ubuntu${UBUNTU_VERSION} as base
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA
# ARG CUDNN=8.1.0.77-1
# ARG CUDNN=8.2.0.53-1
ARG CUDNN=8.2.2.26-1
ARG CUDNN_MAJOR_VERSION=8
ARG LIB_DIR_PREFIX=x86_64
# ARG LIBNVINFER=7.2.2-1
# ARG LIBNVINFER_MAJOR_VERSION=7

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

# Workaround for nvidia.cn repo
RUN rm -rf /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list \ 
    && apt-key adv --fetch-keys https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub \
    && echo "deb https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list

# Pick up some TF dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
    build-essential \
    cuda-command-line-tools-${CUDA/./-} \
    libcublas-${CUDA/./-} \
    cuda-nvrtc-${CUDA/./-} \
    libcufft-${CUDA/./-} \
    libcurand-${CUDA/./-} \
    libcusolver-${CUDA/./-} \
    libcusparse-${CUDA/./-} \
    curl \
    libcudnn8=${CUDNN}+cuda${CUDA} \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libzmq3-dev \
    pkg-config \
    software-properties-common \
    unzip \
    && apt-mark hold libcudnn8 \
    && apt-get autoremove -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*


# Install TensorRT if not building for PowerPC
# NOTE: libnvinfer uses cuda11.1 versions
# RUN [[ "${ARCH}" = "ppc64le" ]] || { apt-get update && \
#     apt-get install -y --no-install-recommends libnvinfer${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda11.1 \
#     libnvinfer-plugin${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda11.1 \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*; }

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig
