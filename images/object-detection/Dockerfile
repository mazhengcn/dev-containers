# syntax=docker/dockerfile:1

FROM zhengma/tensorflow:py310-cu115 AS tf-base
RUN useradd -ms /bin/bash tensorflow

FROM tf-base as od-build

# Install apt dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends build-essential git gcc wget \
    # gpg-agent \
    # python3-cairocffi \
    protobuf-compiler \
    # python3-pil \
    # python3-lxml \
    # python3-tk \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

USER tensorflow
WORKDIR /home/tensorflow
RUN git clone https://github.com/tensorflow/models.git \
    && (cd /home/tensorflow/models/research/ && protoc object_detection/protos/*.proto --python_out=.)

WORKDIR /home/tensorflow/models/research/
RUN cp object_detection/packages/tf2/setup.py ./ \
    && python -m pip install --no-cache-dir --upgrade pip \
    && python -m pip install --no-cache-dir .

FROM tf-base

ENV PATH="/home/tensorflow/.local/bin:${PATH}" \
    TF_CPP_MIN_LOG_LEVEL=3

# Copy this version of of the model garden into the image
COPY --from=od-build /home/tensorflow/models /home/tensorflow/models
COPY --from=od-build /home/tensorflow/.local /home/tensorflow/.local

USER tensorflow
WORKDIR /home/tensorflow/models/research
