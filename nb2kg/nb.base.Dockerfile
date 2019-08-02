# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# based on: https://github.com/IzODA/jupyterhub/blob/master/Dockerfile.notebook

FROM jupyter/minimal-notebook:6c3390a9292e  
ARG MINICONDA_VERSION
ARG JUPYTERHUB_VERSION

# install desired jupyterhub version, jupyter_conda extension. install nb2kg ext. with conda's pip
# separate RUN instr to avoid cache busting (going through the install process on build) on any version changes 
RUN conda install -c conda-forge --quiet --yes jupyterhub==${JUPYTERHUB_VERSION} jupyter_conda==2.5.1 && \
    jupyter serverextension enable --py jupyterlab --sys-prefix && \
    jupyter labextension install jupyterlab_toastify jupyterlab_conda
    
# install pip by default for conda envs for seamless package installation
# install ipykernel 
#conda config --append create_default_packages ipykernel
#conda config --append create_default_packages pycrypto
RUN conda init bash && conda config --set add_pip_as_python_dependency True && \
    echo "export CONDA_DEFAULT_ENV=${JUPYTERHUB_USER}" >> /home/jovyan/.bashrc && \
    conda install -c conda-forge nb_conda_kernels

# add scripts and config as late as possible for shorter rebuilds
# for starting nb server with JupyterHub 
ADD ./start-singleuser.sh /usr/local/bin/start-singleuser.sh
# TODO: confirm which path works
ADD ./base_jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
ADD ./base_jupyter_notebook_config.py /opt/conda/etc/jupyter/jupyter_notebook_config.py
# TODO: confirm this can be eliminated
ADD ./start.sh /usr/local/bin/start.sh

CMD start-singleuser.sh 
