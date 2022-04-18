# syntax=docker/dockerfile:1

ARG CUDA_MAJOR_VERSION=11
ARG CUDA_MINOR_VERSION=6
ARG CUDA_PATCH_VERSION=2
ARG CUDA_VERSION=${CUDA_MAJOR_VERSION}.${CUDA_MINOR_VERSION}
ARG CUDNN_MAJOR_VERSION=8
ARG NVINFER_MAJOR_VERSION=8

FROM nvidia/cuda:${CUDA_VERSION}.${CUDA_PATCH_VERSION}-cudnn${CUDNN_MAJOR_VERSION}-devel-ubuntu20.04 AS lib
ARG NVINFER_MAJOR_VERSION
# Workaround for nvidia.cn repo
RUN rm -rf /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-key adv --fetch-keys https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub \
    && echo "deb https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnvinfer${NVINFER_MAJOR_VERSION} libnvinfer-plugin${NVINFER_MAJOR_VERSION} \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

FROM python:3.10-slim-bullseye
ARG CUDA_MAJOR_VERSION
ARG CUDA_VERSION
ARG CUDNN_MAJOR_VERSION
ARG NVINFER_MAJOR_VERSION
SHELL ["/bin/bash", "-c"]

COPY --from=lib /usr/local/cuda/compat /usr/local/cuda/compat
COPY --from=lib /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1
COPY --from=lib \
    /usr/local/cuda/lib64/libcublas.so.${CUDA_MAJOR_VERSION} \
    /usr/local/cuda/lib64/libcublasLt.so.${CUDA_MAJOR_VERSION} \
    /usr/local/cuda/lib64/libcudart.so.${CUDA_MAJOR_VERSION}.0 \
    /usr/local/cuda/lib64/libcufft.so.10 \
    /usr/local/cuda/lib64/libcufftw.so.10 \
    /usr/local/cuda/lib64/libcuinj64.so.${CUDA_VERSION} \
    /usr/local/cuda/lib64/libcupti.so.${CUDA_VERSION} \
    /usr/local/cuda/lib64/libcurand.so.10 \
    /usr/local/cuda/lib64/libcusolver.so.${CUDA_MAJOR_VERSION} \
    /usr/local/cuda/lib64/libcusolverMg.so.${CUDA_MAJOR_VERSION} \
    /usr/local/cuda/lib64/libcusparse.so.${CUDA_MAJOR_VERSION} \
    /usr/local/cuda/lib64/libnvperf_*.so \
    /usr/local/cuda/lib64/libnvrtc-builtins.so.${CUDA_VERSION} \
    /usr/local/cuda/lib64/libnvrtc.so.${CUDA_MAJOR_VERSION}.2 \
    /usr/local/cuda/lib64/
COPY --from=lib \
    /usr/lib/x86_64-linux-gnu/libcudnn.so.${CUDNN_MAJOR_VERSION} \
    /usr/lib/x86_64-linux-gnu/libcudnn_adv_infer.so.${CUDNN_MAJOR_VERSION} \
    /usr/lib/x86_64-linux-gnu/libcudnn_adv_train.so.${CUDNN_MAJOR_VERSION} \
    /usr/lib/x86_64-linux-gnu/libcudnn_cnn_infer.so.${CUDNN_MAJOR_VERSION} \
    /usr/lib/x86_64-linux-gnu/libcudnn_cnn_train.so.${CUDNN_MAJOR_VERSION} \
    /usr/lib/x86_64-linux-gnu/libcudnn_ops_infer.so.${CUDNN_MAJOR_VERSION} \
    /usr/lib/x86_64-linux-gnu/libcudnn_ops_train.so.${CUDNN_MAJOR_VERSION} \
    /usr/lib/x86_64-linux-gnu/libnvinfer.so.${NVINFER_MAJOR_VERSION} \
    /usr/lib/x86_64-linux-gnu/libnvinfer_plugin.so.${NVINFER_MAJOR_VERSION} \
    /usr/lib/x86_64-linux-gnu/
COPY --from=lib /usr/local/cuda/bin/ptxas /usr/local/cuda/bin/ptxas

ENV PATH=/usr/local/cuda/bin:$PATH \
    LIBRARY_PATH=/usr/local/cuda/lib64/stubs \
    LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/lib/x86_64-linux-gnu \
    LC_ALL=C.UTF-8
