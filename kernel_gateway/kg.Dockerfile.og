# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# based on: https://github.com/jupyter/nb2kg/blob/master/Dockerfile.kg

FROM nvcr.io/nvidia/tensorflow:19.05-py3 

ENV PATH /usr/local/cuda/bin/:$PATH
ENV LD_LIBRARY_PATH /usr/local/cuda/lib:/usr/local/cuda/lib64
LABEL com.nvidia.volumes.needed="nvidia_driver"
RUN pip install jupyter_kernel_gateway

# run kernel gateway, not notebook server
EXPOSE 8888
CMD ["jupyter", "kernelgateway", "--KernelGatewayApp.ip=0.0.0.0", "--KernelGatewayApp.port=8888"]
