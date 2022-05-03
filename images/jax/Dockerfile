# syntax=docker/dockerfile:1

ARG VERSION=0.3.9
ARG PYTHON_VERSION=3.10
ARG CUDA_VERSION=11.6

FROM python:${PYTHON_VERSION}-slim-bullseye AS py
ARG VERSION

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends git \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade --no-cache-dir pip \
    && python -m pip --no-cache-dir install \
    absl-py==1.0.0 \
    ml-collections==0.1.1 \
    numpy==1.22.3 \
    jax[cuda]==${VERSION} -f https://storage.googleapis.com/jax-releases/jax_releases.html \
    dm-haiku==0.0.6 \
    optax==0.1.2 \
    tensorflow-datasets==4.5.2 \
    tensorflow-cpu==2.8.0 \
    chex==0.1.3

FROM zhengma/python-3-cuda:${PYTHON_VERSION}-${CUDA_VERSION}
ARG PYTHON_VERSION

COPY --from=py /usr/local/lib/python${PYTHON_VERSION}/site-packages /usr/local/lib/python${PYTHON_VERSION}/site-packages
