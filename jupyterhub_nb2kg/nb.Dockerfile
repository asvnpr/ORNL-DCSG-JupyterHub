# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# based on: https://github.com/IzODA/jupyterhub/blob/master/Dockerfile.notebook

ARG JUPYTERHUB_VERSION
FROM jupyter/minimal-notebook:abdb27a6dfbb 

USER root
COPY ./start-nb2kg-singleuser.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-nb2kg-singleuser.sh
# Do the pip installs as the unprivileged notebook user
USER jovyan

ENV JUPYTERHUB_VERSION $JUPYTER_HUB_VERSION

RUN conda uninstall jupyterhub && pip install jupyterhub==1.0.0 nb2kg==0.7.0 && \
     jupyter serverextension enable --py nb2kg --sys-prefix
