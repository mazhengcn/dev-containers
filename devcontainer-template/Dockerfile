FROM zhengma/python-cuda:11.2.2

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

# Setup default python tools in a venv via pipx to avoid conflicts
ENV PIPX_HOME=/usr/local/py-utils \
    PIPX_BIN_DIR=/usr/local/py-utils/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}
RUN bash -c "$(curl -fsSL "https://raw.githubusercontent.com/microsoft/vscode-dev-containers/main/script-library/python-debian.sh")" -- "none" "/usr/local" "${PIPX_HOME}" "${USERNAME}" \ 
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Options:
#   tensorflow
#   tensorflow-gpu
#   tf-nightly
#   tf-nightly-gpu
# Set --build-arg TF_PACKAGE_VERSION=1.11.0rc0 to install a specific version.
# Installs the latest version by default.
# ARG TF_PACKAGE=tensorflow
# ARG TF_PACKAGE_VERSION=
# RUN pip3 install --upgrade pip \
#     && pip3 install --no-cache-dir ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}} \
#     && pip3 install --no-cache-dir --upgrade jax[cuda111] -f https://storage.googleapis.com/jax-releases/jax_releases.html \
#     && pip3 install --no-cache-dir git+https://github.com/deepmind/dm-haiku \
#     && pip3 install --no-cache-dir git+git://github.com/deepmind/optax.git
