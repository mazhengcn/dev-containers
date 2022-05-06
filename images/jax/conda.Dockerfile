# syntax=docker/dockerfile:1

ARG VERSION=0.3.10
ARG CUDA_MAJOR_VERSION=11
ARG CUDA_MINOR_VERSION=6
ARG CUDA_PATCH_VERSION=2
ARG CUDA_VERSION=${CUDA_MAJOR_VERSION}.${CUDA_MINOR_VERSION}
ARG CUDNN_MAJOR_VERSION=8
ARG PYTHON_VERSION=3.10
ARG PYTHON_PATH=/usr/local/python

FROM mambaorg/micromamba AS build
ARG CUDA_VERSION
ARG CUDNN_MAJOR_VERSION
ARG PYTHON_VERSION
ARG PYTHON_PATH
# Use bash to support string substitution.
SHELL ["/bin/bash", "-c"]
USER root

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    tzdata build-essential cmake git wget \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install conda packages.
RUN micromamba create -p ${PYTHON_PATH} -c conda-forge -c nvidia \
    python=${PYTHON_VERSION} pip \
    cudatoolkit=${CUDA_VERSION} cudnn=${CUDNN_MAJOR_VERSION}\
    && micromamba clean -ya

# Install pip packages.
RUN ${PYTHON_PATH}/bin/python -m pip install --upgrade --no-cache-dir pip \
    && ${PYTHON_PATH}/bin/python -m pip install --no-cache-dir \
    absl-py>=1.0.0 \
    ml-collections>=0.1.1 \
    numpy>=1.22.2 \
    jax[cuda]>=${VERSION} -f https://storage.googleapis.com/jax-releases/jax_releases.html \
    dm-haiku>=0.0.6 \
    optax>=0.1.2 \
    tensorflow-datasets>=4.5.2 \
    tensorflow-cpu>=2.8.0

FROM nvidia/cuda:${CUDA_VERSION}.${CUDA_PATCH_VERSION}-cudnn${CUDNN_MAJOR_VERSION}-devel-ubuntu20.04 AS lib

FROM debian:bullseye-slim
ARG PYTHON_PATH
SHELL ["/bin/bash", "-c"]

COPY --from=build ${PYTHON_PATH} ${PYTHON_PATH}
COPY --from=lib /usr/local/cuda/bin/ptxas /usr/local/bin/ptxas

ENV PATH=${PYTHON_PATH}/bin:$PATH \
    LC_ALL=C.UTF-8
