#! /usr/bin/env bash

# WARNING!: only run this during initial build and environment setup 
# or when you add new data directly on the host

# this assumes this script and all data dirs are located at the base dir of the project 
PROJECT_DIR=$(dirname $(readlink -f "$0"))

# modify paths to data accordingly for your deployment
GLOBAL_DATA_DIR=$PROJECT_DIR/global_data
USER_DATA_DIR=$PROJECT_DIR/user_data
USER_NOTEBOOKS_DIR=$PROJECT_DIR/user_notebooks

# create temporary container to mount our shareable volumes
echo "Creating temporary container 'data-setup' to mount our project's docker volumes and populate them with our data..." 
docker create --name data-setup \
	-v hub-global-data:/global_data \
	-v hub-user-data:/user_data \
	-v hub-user-notebooks:/user_notebooks \
	busybox
if [ $? -eq 0 ]; then 
	echo "data-setup created and volumes were mounted successfully!"
else
	echo "ERROR! Container creation or volume mounting failed. Exiting..."
	exit 1
fi
# populate docker volumes: 
# copy our data in the host to the volume mount points in the temp container
echo -e "\nCopying data from $GLOBAL_DATA_DIR to hub-global-data docker volume..."
docker cp $GLOBAL_DATA_DIR data-setup:/global_data
if [ $? -eq 0 ]; then echo -e "Done 1/3.\n"; else echo -e "Failed! Continuing with next dir...\n"; fi

echo "Copying data from $USER_DATA_DIR to hub-user-data docker volume..."
docker cp $USER_DATA_DIR data-setup:/user_data
if [ $? -eq 0 ]; then echo -e "Done 2/3.\n"; else echo -e "Failed! Continuing with next dir...\n"; fi

echo "Copying data from $USER_NOTEBOOKS_DIR to hub-user-notebooks docker volume..."
docker cp $USER_NOTEBOOKS_DIR data-setup:/user_notebooks
if [ $? -eq 0 ]; then echo -e "Done 3/3.\n"; else echo -e "Failed! Continuing with container deletion...\n"; fi

# remove/delete our temporary container
echo -e "Finished! Deleting temp container data-setup...\n"
docker rm data-setup


echo -e "NOTE: after checking that the volumes were populated successfully, you should consider deleting the original data or moving it elsewhere.\
	\nThis is because this data will be duplicated in the docker container and therefore the original is wasting diskspace.\
	\nYou can check the location with docker volume inspect --format '{{ .Mountpoint }}' <docker-volume-name>"

