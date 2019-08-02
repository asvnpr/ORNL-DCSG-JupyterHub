#! /bin/bash

export $(grep -v '^#' /home/jovyan/nb.env | xargs -d '\n')

export NB_PORT=${NB_PORT}
export GATEWAY_HOST=${GATEWAY_HOST}
export KG_URL=${KG_URL:-http://${GATEWAY_HOST}:${NB_PORT}}
export KERNEL_USERNAME=${JUPYTERHUB_USER}
export KG_REQUEST_TIMEOUT=${KG_REQUEST_TIMEOUT:-30}

echo "Starting nb2kg against gateway: " ${KG_URL}
echo "Nootbook port: " ${NB_PORT}
echo "Kernel user: " ${KERNEL_USERNAME}

echo "${@: -1}"

# leave user .bashrc configured on spawn
conda init
# install pip by default for conda envs for seamless package installation
conda config --set add_pip_as_python_dependency True
# install ipykernel and pycrypto 
#conda config --append create_default_packages ipykernel
#conda config --append create_default_packages pycrypto
#conda create -n ${JUPYTERHUB_USER}
# env_to_kernel.py -e ${JUPYTERHUB_USER}
exec /usr/local/bin/start-singleuser.sh
