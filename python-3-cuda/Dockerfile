FROM zhengma/cuda:11.4.1

ARG INSTALL_ZSH="false"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME="none"
ARG USER_UID=0
ARG USER_GID=$USER_UID
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Install python3-env
    && apt-get -y install --no-install-recommends curl ca-certificates \
    # Install common packages, non-root user
    && bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/common-debian.sh")" -- "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ARG PYTHON_VERSION="3.9"
# Setting $BASH_ENV and the SHELL command will not result in .bashrc being sourced when
# you supply the program to run as an argument to the "docker run" command.
# Manually add directory for micromamba installed executables to PATH as a workaround.
ENV MAMBA_ROOT_PREFIX="/opt/conda"
ENV PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"
RUN curl -L https://micromamba.snakepit.net/api/micromamba/linux-64/latest | \
    tar -xj -C /usr/local bin/micromamba

RUN micromamba install -qy -n base python=${PYTHON_VERSION} pip -c conda-forge \
    && micromamba clean

# Setup default python tools in a venv via pipx to avoid conflicts
ENV PIPX_HOME=/usr/local/py-utils \
    PIPX_BIN_DIR=/usr/local/py-utils/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}
RUN bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/python-debian.sh")" -- "none" "/opt/conda" "${PIPX_HOME}" "${USERNAME}" \ 
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*
