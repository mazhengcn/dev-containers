# syntax=docker/dockerfile:1

ARG VERSION=2.8.0
ARG PYTHON_VERSION=3.10
ARG CUDA_VERSION=11.6

FROM python:${PYTHON_VERSION}-slim-bullseye AS py
ARG VERSION

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends git \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade --no-cache-dir pip \
    && python -m pip --no-cache-dir install \
    absl-py>=1.0.0 \
    ml-collections>=0.1.1 \
    numpy>=1.22.2 \
    tensorflow>=${VERSION}

FROM zhengma/python-3-cuda:${PYTHON_VERSION}-${CUDA_VERSION}
ARG PYTHON_VERSION

COPY --from=py /usr/local/lib/python${PYTHON_VERSION}/site-packages /usr/local/lib/python${PYTHON_VERSION}/site-packages
