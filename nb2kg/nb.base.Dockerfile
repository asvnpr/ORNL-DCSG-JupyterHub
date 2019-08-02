# Ubuntu:Bionic
# CUDA: 10.0
# this tag corresponds to the dockerfile in this commit:
# https://github.com/tensorflow/tensorflow/blob/2a40f531ffadacb602071c77938fed0eef81f6d4/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile
# based on the above dockerfile and the jupyter base notebook dockerfile:
# https://hub.docker.com/r/jupyter/base-notebook/dockerfile 
FROM tensorflow/tensorflow:1.13.2-gpu-py3

ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"
ARG NB_GRP="users"
ARG MINICONDA_VERSION=4.6.14
ARG CONDA_VERSION=4.7.10
ARG JUPYTERHUB_VERSION

USER root

# added some packages from base and minimal notebooks in 
# https://github.com/jupyter/docker-stacks/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -yq \
    build-essential \
    vim \
    nano \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    python3-dev \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    tzdata \
    unzip \
    wget \
    bzip2 \
    ca-certificates \ 
    sudo \ 
    locales \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV CONDA_DIR=/opt/conda/
ENV PATH=${CONDA_DIR}/bin:$PATH \
    HOME=/home/$NB_USER \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# script for correcting permissions
ADD ./fix-permissions /usr/local/bin/fix-permissions 

RUN useradd -m -s /bin/bash -N --uid ${NB_UID} --gid ${NB_GID} ${NB_USER}

# install and config conda in separate run instr for any miniconda version changes 
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \ 
    chmod +x ~/miniconda.sh && ~/miniconda.sh -b -p $CONDA_DIR && rm ~/miniconda.sh && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "source activate base" >> ~/.bashrc && \
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    ${CONDA_DIR}/bin/conda config --system --prepend channels conda-forge && \
    ${CONDA_DIR}/bin/conda config --system --set auto_update_conda false && \
    ${CONDA_DIR}/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda install --quiet --yes conda && \
    ${CONDA_DIR}/bin/conda update --all --quiet --yes && \
    conda clean --all -f -y && \
    chown ${NB_USER}:${NB_GID} ${CONDA_DIR} && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions ${HOME}

USER ${ND_USER}
# runs any run instruction in this dir
WORKDIR ${HOME}

# install tini, jupyterhub, lab, notebook 
# jupyter_conda extension (for conda interface), nb_conda_kernels to automatically make kernels out of your env
# jupyter_conda: https://github.com/fcollonval/jupyter_conda
# nb_conda_kernels: https://github.com/Anaconda-Platform/nb_conda_kernels
# separate RUN instr to avoid cache busting (going through the install process on build) on any version changes 
RUN conda install -c conda-forge --quiet --yes \
    'tini=0.18.0' \
    'notebook==6.0.0' \
    'jupyterlab=1.0.4' \
    jupyterhub==${JUPYTERHUB_VERSION} \
    jupyter_conda \
    nb_conda_kernels && \ 
    jupyter serverextension enable --py jupyterlab --sys-prefix && \
    jupyter labextension install jupyterlab_toastify jupyterlab_conda
    
# install pip by default for conda envs for seamless package installation
RUN conda init bash && conda config --set add_pip_as_python_dependency True && \
    echo "export CONDA_DEFAULT_ENV=${JUPYTERHUB_USER}" >> /home/jovyan/.bashrc && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# add scripts and config as late as possible for shorter rebuilds
# for starting nb server with JupyterHub 
ADD ./start-singleuser.sh /usr/local/bin/start-singleuser.sh
# TODO: confirm which path works
ADD ./base_jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
ADD ./base_jupyter_notebook_config.py /opt/conda/etc/jupyter/jupyter_notebook_config.py
# TODO: confirm this can be eliminated
ADD ./start.sh /usr/local/bin/start.sh

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD start-singleuser.sh 

# Fix permissions on /etc/jupyter as root
USER root
RUN fix-permissions /etc/jupyter/

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER
