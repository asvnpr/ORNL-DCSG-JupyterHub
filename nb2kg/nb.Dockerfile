# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# based on: https://github.com/IzODA/jupyterhub/blob/master/Dockerfile.notebook
ARG BASE_NB_IMG
FROM $BASE_NB_IMG 

ARG MINICONDA_VERSION
ARG JUPYTERHUB_VERSION
ARG NB2KG_VERSION

# use conda pip instead of system pip
# had to remove because of impossibly slow or failing build: fix-permissions $CONDA_DIR 
RUN  $CONDA_DIR/bin/pip install "nb2kg==${NB2KG_VERSION}" && conda clean --all -y && \
    jupyter serverextension enable --py nb2kg --sys-prefix 

ARG KG_URL
ARG GATEWAY_HOST
ARG KG_AUTH_TOKEN
ARG NB_PORT

ENV KG_URL ${KG_URL}
ENV GATEWAY_HOST ${GATEWAY_HOST}
#ENV KG_AUTH_TOKEN ${KG_AUTH_TOKEN}
ENV NB_PORT ${NB_PORT}

# add ladd scripts and config as late as possible for shorter rebuilds
# for starting nb2kg notebook server with JupyterHub and connecting to kernel-gateway
ADD ./start-nb2kg.sh /usr/local/bin/start-nb2kg.sh
ADD ./start-singleuser.sh /usr/local/bin/start-singleuser.sh
ADD ./start.sh /usr/local/bin/start.sh
ADD ./jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
ADD ./jupyter_notebook_config.py /opt/conda/etc/jupyter/jupyter_notebook_config.py
Add ./env_to_kernel.py /usr/bin/env_to_kernel.py

CMD start-nb2kg.sh 
