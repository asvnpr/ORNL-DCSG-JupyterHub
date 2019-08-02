#! /usr/bin/env bash

# export all vars in .env. excessive, but bash has no easy way to parse the file
export $(grep -v '^#' .env | xargs -d '\n')

# use local persist plugin to mount source to our host dirs
# driver: https://github.com/MatchbookLab/local-persist
docker volume create -d local-persist -o mountpoint=$(readlink -f $USER_KERNELS_HOST_DIR) --name=$USER_KERNELS_VOLUME

docker volume create -d local-persist -o mountpoint=$(readlink -f $USER_ENV_HOST_DIR) --name=$USER_ENV_VOLUME

docker volume create -d local-persist -o mountpoint=$(readlink -f $USER_WORK_HOST_DIR) --name=$USER_WORK_VOLUME

docker volume create -d local-persist -o mountpoint=$(readlink -f $GLOBAL_DATA_HOST_DIR) --name=$GLOBAL_DATA_VOLUME

docker volume create -d local-persist -o mountpoint=$(readlink -f $HUB_DB_HOST_DIR) --name=$HUB_DB_VOLUME
