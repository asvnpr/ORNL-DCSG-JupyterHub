# Ubuntu:Bionic
# CUDA: 10.0
# this tag corresponds to the dockerfile in this commit:
# https://github.com/tensorflow/tensorflow/blob/2a40f531ffadacb602071c77938fed0eef81f6d4/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile
FROM tensorflow/tensorflow:1.13.2-gpu-py3

ARG KERNEL_USER="jovyan"
ARG KERNEL_UID="1000"
ARG KERNEL_GID="100"
ARG KERNEL_GRP="users"
ARG MINICONDA_VERSION=4.6.14
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$KERNEL_USER \
    DEBIAN_FRONTEND=noninteractive

# based on elyra/kernel-tf-gpu-py
# added some packages from base and minimal notebooks in 
# https://github.com/jupyter/docker-stacks/
RUN apt-get update && apt-get install -yq \
    build-essential \
    libsm6 \
    libxext-dev \
    libxrender1 \
    netcat \
    python3-dev \
    tzdata \
    unzip \
    wget \
    bzip2 \
    ca-certificates \ 
    sudo \ 
    && rm -rf /var/lib/apt/lists/*

RUN pip install pycrypto

ADD ./jupyter_enterprise_gateway_kernel_image_files* /usr/local/bin/

USER root

RUN adduser --system --uid ${KERNEL_UID} --gid ${KERNEL_GID} ${KERNEL_USER} && \
    chown ${KERNEL_USER}:${KERNEL_GRP} /usr/local/bin/bootstrap-kernel.sh && \
    chmod 0755 /usr/local/bin/bootstrap-kernel.sh && \
    chown -R ${KERNEL_USER}:${KERNEL_GRP} /usr/local/bin/kernel-launchers

# separate run instr for any miniconda version changes 
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \ 
    chmod +x ~/miniconda.sh && ~/miniconda.sh -b -p $CONDA_DIR && rm ~/miniconda.sh && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda update --all --quiet --yes 

# script for correcting permissions
ADD ./fix-permissions /usr/local/bin/fix-permissions 
RUN fix-permissions $CONDA_DIR && fix-permissions /home/$KERNEL_USER

USER jovyan
ENV KERNEL_LANGUAGE python
CMD /usr/local/bin/bootstrap-kernel.sh
