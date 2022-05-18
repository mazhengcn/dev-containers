# syntax=docker/dockerfile:1

ARG VERSION=2.9.0
ARG PYTHON_VERSION=3.10
ARG CUDA_VERSION=11.6

FROM python:${PYTHON_VERSION}-slim AS py
ARG VERSION

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install --no-install-recommends -y \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade --no-cache-dir pip \
    && python -m pip install --no-cache-dir \
    absl-py>=1.0.0 \
    ml-collections>=0.1.1 \
    numpy>=1.22.2 \
    tensorflow>=${VERSION}

FROM zhengma/python-3-cuda:${PYTHON_VERSION}-${CUDA_VERSION}
ARG PYTHON_VERSION

COPY --from=py /usr/local/lib/python${PYTHON_VERSION}/site-packages /usr/local/lib/python${PYTHON_VERSION}/site-packages
