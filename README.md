# Discrete Computing Systems Group: Scalable, Distributable JupyterHub Team Server

## Overview

### 1. Objectives

### 2. Architecture 

## System Setup

# **NOTE**: a

### 0. General description of this project
    This was my main project as part of my appointment in the National Consortium for Graduate Degrees for Minorities in Engineering and Science Inc. (GEM)  
    program at the Oak Ridge National Laboratory (ORNL) during the summer of 2019. Under the guidance of [Dr. Perumalla], I was tasked in developing a  
    Jupyter server for the Discrete Computing Systems Group (DCSG) that satisfied their initial requirements and any later feedback. Some of these requirements  
    were multi-user server, ability to execute code in remote kernels to leverage the team's more powerful hardware, and possibility of containerization for  
    portability and deployment. 
      
    Here is an outline of the resulting implemented system:
    * 

### 1. Full Dependencies and Requirements Summary:
* Supported Linux system (Ubuntu >= 16.04, Fedora >= 28)
* Compatible Nvidia GPU
* pip or conda
* Nvidia GPU Driver 
* docker engine (>= 19.03)
* Nvidia docker container runtime 
* jupyter notebook AND jupyterhub (see section 0) 

### 1. System and User Pre-requisites:
* [CUDA-capable Nvidia GPU and \*nix system](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/#system-requirements)
* [Supported docker version](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#which-docker-packages-are-supported) of docker
([Docker installation instructions](https://docs.docker.com/install/))
* Satisfaction of [JupyterHub pre-requisites](https://jupyterhub.readthedocs.io/en/stable/quickstart.html)
* nvidia container runtime ([installation instructions](https://github.com/nvidia/nvidia-container-runtime#installation))
	* **NOTE** Your host OS and arch should be supported both by [docker >= 19.03](https://docs.docker.com/install/linux/docker-ce/ubuntu/#os-requirements)
and the [nvidia-runtime](https://nvidia.github.io/nvidia-container-runtime/#repository-configuration))
	* GPU workload performance impact is stated to be insignificant (<1%) but be aware of 
[these details](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#does-it-have-a-performance-impact-on-my-gpu-workload) 
	* If server is experiencing frequent slow GPU process startups, the 
[persistence-daemon](https://docs.nvidia.com/deploy/driver-persistence/index.html#persistence-daemon) should be enabled
* Working knowledge of shell usage and a \*nix system
* Working knowledge of docker, docker compose ([their tutorial](https://docs.docker.com/get-started/)
and [glossary](https://docs.docker.com/glossary/) are very helpful)
* It's not necessary, but it helps to be familiar with the 
[docker python sdk](https://docker-py.readthedocs.io/en/stable/containers.html) 
* Knowledge on basic networking, and setting up domains and certificates

### 2. Nvidia GPU drivers and libraries:  

1. Graphics Drivers:

* `sudo add-apt-repository ppa:graphics-drivers/ppa && sudo apt update`
* `sudo apt install nvidia-<XXX>`  
where XXX should match the cuda version you will install below.
See Cuda Toolkit and Nvidia Driver compatibility chart
[here](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/) under "CUDA Driver"  

3. nvidia-docker runtime configuration:
    TBD

### 

### 4. Building Docker images
	This repo has been setup to depend on [docker-compose](https://docs.docker.com/compose/) exclusively on the build process and environment setup.  
    This makes the build and deploy process much easier, but makes customization or using only parts of this repo a bit harder. You can set up a make 
    file that uses the `docker build` cmd, but you'd have to manually setup the env vars yourself per image and make sure the containers run on the same  
    network and are discoverable. Here I'll limit the instructions to using docker-compose under different scenarios:
