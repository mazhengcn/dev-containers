# syntax=docker/dockerfile:1

ARG VERSION=0.3.15
ARG PYTHON_VERSION=3.10
ARG CUDA_VERSION=11.6

FROM python:${PYTHON_VERSION}-slim-bullseye AS py
ARG VERSION

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install --no-install-recommends -y \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade --no-cache-dir pip \
    && python -m pip install --no-cache-dir \
    absl-py>=1.0.0 \
    jax[cuda]>=${VERSION} -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
    numpy>=1.22.3 \
    tensorflow-cpu>=2.9.0 \
    tensorflow-datasets>=4.5.2

# Install customized jaxline
RUN python -m pip install --no-cache-dir \
    git+https://github.com/deepmind/chex \
    git+https://github.com/deepmind/dm-haiku \
    git+https://github.com/deepmind/optax \
    git+https://github.com/google/ml_collections \
    git+https://github.com/mazhengcn/jaxline

FROM zhengma/python-3-cuda:${PYTHON_VERSION}-${CUDA_VERSION}
ARG PYTHON_VERSION

COPY --from=py /usr/local/lib/python${PYTHON_VERSION}/site-packages /usr/local/lib/python${PYTHON_VERSION}/site-packages
