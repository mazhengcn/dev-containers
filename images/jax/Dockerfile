# syntax=docker/dockerfile:1

ARG VERSION=0.3.13
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
    chex>=0.1.3 \
    dm-haiku>=0.0.6 \
    jax[cuda]>=${VERSION} -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
    ml-collections>=0.1.1 \
    numpy>=1.22.3 \
    optax>=0.1.2 \
    tensorflow-cpu>=2.9.0 \
    tensorflow-datasets>=4.5.2

FROM zhengma/python-3-cuda:${PYTHON_VERSION}-${CUDA_VERSION}
ARG PYTHON_VERSION

COPY --from=py /usr/local/lib/python${PYTHON_VERSION}/site-packages /usr/local/lib/python${PYTHON_VERSION}/site-packages
