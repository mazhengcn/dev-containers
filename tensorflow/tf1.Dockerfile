FROM nvcr.io/nvidia/tensorflow:21.06-tf1-py3

# Copy library scripts to execute
COPY ./library-scripts/*.sh ./library-scripts/*.env /tmp/library-scripts/

ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME="none"
ARG USER_UID=0
ARG USER_GID=$USER_UID
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Install python3-env
    && apt-get -y install --no-install-recommends python3-venv \
    && ln -s $(which python${PYTHON_VERSION}) /usr/local/bin/python \
    # Install common packages, non-root user
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Setup default python tools in a venv via pipx to avoid conflicts
ENV PIPX_HOME=/usr/local/py-utils \
    PIPX_BIN_DIR=/usr/local/py-utils/bin
ENV PATH=${PATH}:${PIPX_BIN_DIR}
RUN bash /tmp/library-scripts/python-debian.sh "none" "/usr/local" "${PIPX_HOME}" "${USERNAME}" \ 
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Remove library scripts for final image
RUN rm -rf /tmp/library-scripts

# # [Optional] Uncomment this section to install additional OS packages.
# # RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
# #     && apt-get -y install --no-install-recommends <your-package-list-here>

# # [Optional] Uncomment this line to install global node packages.
# # RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

# # Options:
# #   tensorflow
# #   tensorflow-gpu
# #   tf-nightly
# #   tf-nightly-gpu
# # Set --build-arg TF_PACKAGE_VERSION=1.11.0rc0 to install a specific version.
# # Installs the latest version by default.
# ARG TF_PACKAGE=tensorflow
# ARG TF_PACKAGE_VERSION=
# RUN pip3 --disable-pip-version-check --no-cache-dir install ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}}
