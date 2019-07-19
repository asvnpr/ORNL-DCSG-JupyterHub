#! /bin/bash

export $(grep -v '^#' /home/jovyan/nb.env | xargs -d '\n')

export NB_PORT=${NB_PORT}
export GATEWAY_HOST=${GATEWAY_HOST}
export KG_URL=${KG_URL:-http://${GATEWAY_HOST}:${NB_PORT}}
#export KG_HTTP_USER=${JUPYTERHUB_USER}
export KG_REQUEST_TIMEOUT=${KG_REQUEST_TIMEOUT:-30}
export KG_HEADERS {\"Authorization\": \"token e409110bc3c69a54fc8e9b639ed9b0783776be38cc1acf5c150051e624fd0625\"}


echo "Starting nb2kg against gateway: " ${KG_URL}
echo "Nootbook port: " ${NB_PORT}
echo "Kernel user: " ${KERNEL_USERNAME}

echo "${@: -1}"


exec /usr/local/bin/start-singleuser.sh
