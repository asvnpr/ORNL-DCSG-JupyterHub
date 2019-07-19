# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# based on: https://github.com/jupyter/nb2kg/blob/master/Dockerfile.kg

FROM elyra/enterprise-gateway:2.0.0rc2 
ARG LOG_LEVEL
ARG CONFIG_DIR 
ARG KG_ALLOW_ORIGIN

ENV PATH /usr/local/cuda/bin/:$PATH
ENV LD_LIBRARY_PATH /usr/local/cuda/lib:/usr/local/cuda/lib64
ENV KG_LOG_LEVEL ${LOG_LEVEL}
ENV KG_CONFIG ${CONFIG_DIR}
ENV KG_ALLOW_ORIGIN ${KG_ALLOW_ORIGIN}

LABEL com.nvidia.volumes.needed="nvidia_driver"
COPY ./kernelspecs/ /usr/local/share/jupyter/kernels
COPY ./jupyter_enterprise_gateway_config.py /etc/jupyter/

# run kernel gateway, not notebook server
#CMD jupyter enterprisegateway --log-level=${KG_LOG_LEVEL} --config=${KG_CONFIG} 
CMD jupyter enterprisegateway --debug --config=/etc/jupyter/jupyter_enterprise_gateway_config.py 
#--JupyterWebsocketPersonality.list_kernels=True
