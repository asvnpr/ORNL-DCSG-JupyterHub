# Discrete Computing Systems Group: Scalable, Distributable JupyterHub Team Server

## Overview

### 1. Objectives

### 2. Architecture 

## System Setup

### 0. Full Dependencies and Requirements Summary:
* \*nix system
* \*Nvidia GPU (see section 0)
* pip or conda
* Nvidia Driver and CUDA Library
* docker
* Nvidia docker container runtime * jupyter notebook AND jupyterhub (see section 0) 

### 1. System and User Pre-requisites:
* [CUDA-capable Nvidia GPU and \*nix system](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/#system-requirements)
* [Supported version](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#which-docker-packages-are-supported) of docker
([Docker installation instructions](https://docs.docker.com/install/))
* Satisfaction of [JupyterHub pre-requisites](https://jupyterhub.readthedocs.io/en/stable/quickstart.html)
* Nvidia Docker runtime:
	* [installation instructions](https://github.com/NVIDIA/nvidia-docker)
	* **NOTE** Pay special attention to the supported Linux version numbers as these should match the available installation candidates
 in the docker repo. ie [version from here should cover](https://docs.docker.com/install/linux/docker-ce/ubuntu/#os-requirements)
should match version from [here](https://nvidia.github.io/nvidia-docker/#repository-configuration)
	* GPU workload performance impact is stated to be insignificant (<1%) but be aware of 
[these details](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#does-it-have-a-performance-impact-on-my-gpu-workload) 
	* If server is experiencing frequent slow GPU process startups, the 
[persistence-daemon](https://docs.nvidia.com/deploy/driver-persistence/index.html#persistence-daemon) should be enabled
* Working knowledge of shell usage and a \*nix system
* Working knowledge of docker ([their tutorial](https://docs.docker.com/get-started/) and
[glossary](https://docs.docker.com/glossary/) are very helpful)
* Knowledge on basic networking, and setting up domains and certificates

### 2. Nvidia GPU drivers and libraries:  

1. Graphics Drivers:

* `sudo add-apt-repository ppa:graphics-drivers/ppa && sudo apt update`
* `sudo apt install nvidia-<XXX>` where XXX should match the cuda version you will install below. See Cuda Toolkit and Nvidia Driver compatibility chart
[here](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/) under "CUDA Driver"  

2. Cuda Dirty and Fast way:

* Verify system compatibility requirements [here](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions)
* Download the appropriate runfile for your distro
[here](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1604&target_type=runfilelocal)
(Ubuntu 16.04 selected in link. Make sure you have the right file: it's a large download and lengthy install process that will fail even between diff. distro versions)
* Add exec permission and run the runfile
* Some more details [here](https://www.pugetsystems.com/labs/hpc/How-To-Install-CUDA-10-1-on-Ubuntu-19-04-1405/)   

3. (Optional) Install CUDA manually if runfile fails:
* check that driver was installed correctly and is loaded with `sudo prime-select query`
* If installed, but not loaded: switch to driver with `sudo prime-select nvidia` and reboot 
* Check driver version with `nvidia-smi` or `cat /proc/driver/nvidia/version` 
* Download appropriate .deb file from
[nvidia](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1604&target_type=deblocal)
(consult compatibility chart above) and follow instructions in link to install  
* Some common errors are dependency failures or old version installs. I hope you have strong google skills if this is the case


