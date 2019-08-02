#! /usr/bin/env bash

# from http://collabnix.com/introducing-new-docker-cli-api-support-for-nvidia-gpus-under-docker-engine-19-03-0-beta-release/
# see here for official repo instructions and updates: https://nvidia.github.io/nvidia-container-runtime/
# see here for info on the runtime itself: https://github.com/nvidia/nvidia-container-runtime 
echo "Adding nvidia-container-runtime gpg key to apt..."
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
echo "Adding nvidia-container-runtime list to apt sources..."
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
echo "Updating apt..."
sudo apt update
echo "Installing nvidia-container-runtime..."
sudo apt -y install nvidia-container-runtime
echo "Adding nvidia runtime to docker daemon's runtimes..."
sudo dockerd --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
