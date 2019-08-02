# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# based on: https://github.com/jupyter/nb2kg/blob/master/Dockerfile.kg
# you can update kernel image versions by downloading them from: 
# https://github.com/jupyter/enterprise_gateway/releases/download/v2.0.0rc2/jupyter_enterprise_gateway_kernelspecs_docker-X.X.X.tar.gz
# where X.X.X is the version number
ARG EG_VERSION
FROM elyra/enterprise-gateway:${EG_VERSION}
ARG LOG_LEVEL
ARG CONFIG_DIR 
ARG KG_ALLOW_ORIGIN
ARG USER_KERNELS_DIR 

ENV PATH /usr/local/cuda/bin/:$PATH
ENV LD_LIBRARY_PATH /usr/local/cuda/lib:/usr/local/cuda/lib64
ENV KG_LOG_LEVEL ${LOG_LEVEL}
ENV KG_CONFIG ${CONFIG_DIR}
ENV KG_ALLOW_ORIGIN ${KG_ALLOW_ORIGIN}
ENV KERNEL_PATH ${USER_KERNELS_DIR}

LABEL com.nvidia.volumes.needed="nvidia_driver"
COPY ./jupyter_enterprise_gateway_config.py /etc/jupyter/
RUN rm -rf /usr/local/share/jupyter/kernels
#COPY ./kernels /usr/local/share/jupyter/kernels
COPY ./launch_docker.py /home/jovyan/launch_docker.py
# overwrite launch_docker.py in all kernels for easy updates 
USER root
RUN chmod +w ${KERNEL_PATH} && \ 
for kernel in $(ls ${KERNEL_PATH} | grep docker); do \cp ~/launch_docker.py ${KERNEL_PATH}/$kernel/scripts/launch_docker.py; done
USER jovyan

# run kernel gateway, not notebook server
CMD jupyter enterprisegateway --debug --config=/etc/jupyter/jupyter_enterprise_gateway_config.py 
