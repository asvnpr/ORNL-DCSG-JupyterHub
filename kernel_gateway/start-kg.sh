#!/bin/bash

LOG=/var/log/enterprise_gateway.log
PIDFILE=/var/run/enterprise_gateway.pid

jupyter enterprisegateway --ip=0.0.0.0 --port_retries=5 --log-level=DEBUG --config=/etc/jupyter/jupyter_enterprise_gatewat_config.py\
   --MappingKernelManager.cull_idle_timeout=21600 --MappingKernelManager.cull_interval=300 > $LOG 2>&1 &

if [ "$?" -eq 0 ]; then
  echo $! > $PIDFILE
else
  exit 1
fi


