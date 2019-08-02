#! /usr/bin/env bash

# create placeholder user with same, HOMEDIR, UID, and GID
# as spawned container so we can bind volumes with appr perissions

JPY_UID=$JPY_UID
JPY_GID=$JPY_GID
JPY_USR=$JPY_USR
JPY_GRP=$JPY_GRP
JPY_HOME=$JPY_HOME

echo "Creating group '${JPY_GRP}' with gid ${JPY_GID}"
addgroup --gid ${JPY_GID} ${JPY_GRP}
echo "Creating user '${JPY_USR}' with uid ${JPY_UID}"
adduser --home "${JPY_HOME}" --uid ${JPY_UID} --ingroup ${JPY_GRP} \
    --shell /bin/bash --disabled-password --quiet ${JPY_USR} 

# fix permissions and ownership for user volume dirs 
# parse values of user volume directories name
fix_own () {
    USER_DIR=$1
    echo "Changing ownership of $USER_DIR to ${JPY_UID}:${JPY_GID}";
    chown -R ${JPY_UID}:${JPY_GID} $USER_DIR;
    echo "Changing permissions of $USER_DIR to 766";
    chmod -R 766 $USER_WORK_DIR;
}

IFS=','; USER_VARS=($USER_VOL_DIRS); unset IFS;
for VAR in "${USER_VARS[@]}"; do
    fix_own $VAR
done

jupyterhub --debug --log-level=0 -f /srv/jupyterhub/jupyterhub_config.py #>> /data/jupyterhub.log
# PROD: jupyterhub --debug -f /srv/jupyterhub/jupyterhub_config.py
