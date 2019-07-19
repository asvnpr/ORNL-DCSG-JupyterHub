# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# based on: https://github.com/whlteXbread/GPU-Jupyterhub/blob/master/Jupyterhub_image/Dockerfile.jupyterhub
#, and: https://github.com/IzODA/jupyterhub/blob/master/Dockerfile.jupyterhub

ARG JUPYTERHUB_VERSION=0.9.6
ARG HOST_SSL_KEY
ARG HOST_SSL_CERT
# jupyterhub-onbuild automaticalls adds jupyter_config.py
FROM jupyterhub/jupyterhub:$JUPYTERHUB_VERSION

# install docker on the jupyterhub container
RUN wget https://get.docker.com -q -O /tmp/getdocker && \
    chmod +x /tmp/getdocker && \
    sh /tmp/getdocker

# Install dockerspawner, oauth, python postgres adapter
# NOTE: initially using nativeauthenticator as we transition to oath
RUN /opt/conda/bin/pip install psycopg2-binary && \
    /opt/conda/bin/pip install --no-cache-dir \
        oauthenticator==0.8.2 \
        dockerspawner==0.11.1 \
        jupyterhub-nativeauthenticator==0.0.4


# Copy TLS certificate and key
# TODO: remove hardcoded paths. maybe implement dockervolume for secrets
COPY ./secrets/ssl/ /srv/jupyterhub/secrets/
#COPY ./dockerspawner.py /opt/conda/lib/python3.6/site-packages/dockerspawner/dockerspawner.py

RUN chmod 700 /srv/jupyterhub/secrets && \
    chmod 600 /srv/jupyterhub/secrets/*

COPY ./userlist /srv/jupyterhub/userlist 
COPY ./jupyterhub_config.py /srv/jupyterhub
