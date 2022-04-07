ARG UBUNTU_VERSION=20.04

ARG ARCH=
ARG CUDA=11.6
FROM nvidia/cuda${ARCH:+-$ARCH}:${CUDA}.1-base-ubuntu${UBUNTU_VERSION}
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA
# 8.2.0.53 for 11.3
# 8.3.1.22 for 11.5
ARG CUDNN=8.4.0.27
ARG CUDNN_MAJOR_VERSION=8
ARG LIB_DIR_PREFIX=x86_64
# ARG LIBNVINFER=7.2.2-1
# ARG LIBNVINFER_MAJOR_VERSION=7

# Copy library scripts to execute
COPY library-scripts/*.sh /tmp/library-scripts/

# Install CUDA libraries needed.
RUN bash /tmp/library-scripts/cuda-ubuntu.sh "${CUDA}" "${CUDNN}" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64

ARG INSTALL_ZSH="false"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=none
ARG USER_UID=0
ARG USER_GID=$USER_UID
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common \
    # Install common packages, non-root user
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ARG PYTHON_VERSION=3.10
ARG PYTHON_PATH=/usr/local/python
ENV PATH=${PYTHON_PATH}/bin:${PATH}
RUN bash /tmp/library-scripts/python-debian.sh "${PYTHON_VERSION}" "${PYTHON_PATH}" "none" "${USERNAME}" "false" "false" "true" "true" \ 
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Remove library scripts for final image
RUN rm -rf /tmp/library-scripts
