FROM zhengma/python-3-cuda:latest

# Options:
#   tensorflow
#   tensorflow-gpu
#   tf-nightly
#   tf-nightly-gpu
# Set --build-arg TF_PACKAGE_VERSION=1.11.0rc0 to install a specific version.
# Installs the latest version by default.
ARG TF_PACKAGE=tf-nightly
ARG TF_PACKAGE_VERSION=
RUN pip3 install --upgrade pip \
    && pip3 install --no-cache-dir ${TF_PACKAGE}${TF_PACKAGE_VERSION:+==${TF_PACKAGE_VERSION}} \
    && pip3 install --no-cache-dir --upgrade jax[cuda111] -f https://storage.googleapis.com/jax-releases/jax_releases.html \
    && pip3 install --no-cache-dir git+https://github.com/deepmind/dm-haiku \
    && pip3 install --no-cache-dir git+git://github.com/deepmind/optax.git