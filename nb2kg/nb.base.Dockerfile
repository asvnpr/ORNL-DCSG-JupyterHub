# Coffiningeeeeeeeeeeeeeeeeeeeeeeeeeepyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# based on: https://github.com/IzODA/jupyterhub/blob/master/Dockerfile.notebook

FROM jupyter/scipy-notebook:6c3390a9292e  
ARG MINICONDA_VERSION
ARG JUPYTERHUB_VERSION
ARG NB2KG_VERSION

ENV CONDA_DIR /home/jovyan/conda 
ENV PATH ${CONDA_DIR}/bin:${PATH}
# add nb2kg vars to global environments to avoid issues w. scripts
ADD ./nb.env /tmp/nb.env
# install any packages missing from base images for miniconda install
# following miniconda Dockerfile: https://hub.docker.com/r/continuumio/miniconda/dockerfile
# remove current conda install and install in jovyan home for easier managing of user envs 
# with docker volumes. fix permissions for start scripts

# Do installs as the unprivileged notebook user
USER jovyan
SHELL ["/bin/bash", "-c", "-l"]


# separate run instr for any miniconda version changes 
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \ 
    chmod +x ~/miniconda.sh && ~/miniconda.sh -b -p $CONDA_DIR && rm ~/miniconda.sh && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda update --all --quiet --yes 

# uninstall any existing jupyterhub install, install desired hub version, and nb2kg with conda's pip
# separate RUN instr to avoid cache busting (going through the conda install process)
# on any version changes to jupyterhub or nb2kg
RUN $CONDA_DIR/bin/conda install -c conda-forge --quiet --yes jupyterhub==${JUPYTERHUB_VERSION} jupyterlab tini==0.18.0 && \
    $CONDA_DIR/bin/jupyter serverextension enable --py jupyterlab --sys-prefix && \
    $CONDA_DIR/bin/conda clean --all -y && fix-permissions $CONDA_DIR && fix-permissions /home/$NB_USER 

# add env vars for kernel gateway
COPY ./nb.env /home/jovyan/nb.env
#RUN for envvar in $(grep -v '^#' ~/nb.env); do echo "export ${envvar}" >> ~/.bashrc; done; rm ~/nb.env 

# add ladd scripts and config as late as possible for shorter rebuilds
# for starting nb2kg notebook server with JupyterHub and connecting to kernel-gateway
ADD ./start-nb2kg.sh /usr/local/bin/start-nb2kg.sh
ADD ./start-singleuser.sh /usr/local/bin/start-singleuser.sh
ADD ./start.sh /usr/local/bin/start.sh
ADD ./jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
ADD ./jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py

ARG KG_URL
ARG GATEWAY_HOST
ENV KG_URL $KG_URL
ENV GATEWAY_HOST ${GATEWAY_HOST}
