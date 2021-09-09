ARG UBUNTU_VERSION=20.04

ARG ARCH=
ARG CUDA=11.4
FROM nvidia/cuda${ARCH:+-$ARCH}:${CUDA}.1-base-ubuntu${UBUNTU_VERSION}
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

# Install CUDA libraries needed.
COPY cuda-ubuntu.sh /tmp/library-scripts/
RUN bash /tmp/library-scripts/cuda-ubuntu.sh "${CUDA}" "${CUDNN}" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/library-scripts/

ARG INSTALL_ZSH="false"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME="none"
ARG USER_UID=0
ARG USER_GID=$USER_UID
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl ca-certificates \
    # Install common packages, non-root user
    && bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh")" -- "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ARG PYTHON_VERSION="3.9.7"
ARG PYTHON_INSTALL_PATH=/usr/local/python
# Setup default python tools in a venv via pipx to avoid conflicts
ENV PIPX_HOME=/usr/local/py-utils \
    PIPX_BIN_DIR=/usr/local/py-utils/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}
RUN bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/python-debian.sh")" -- "${PYTHON_VERSION}" "${PYTHON_INSTALL_PATH}" "${PIPX_HOME}" "automatic" "true" "true" "false" \ 
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*
