# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# adapted from https://github.com/whlteXbread/GPU-Jupyterhub/blob/master/jupyterhub_config.py
#, and: https://github.com/IzODA/jupyterhub/blob/master/jupyterhub_config.py

# Configuration file for JupyterHub
import os
c = get_config()

# auth token captured by env var, but uncomment if you change the var's name
c.ConfigurableHTTPProxy.auth_token = os.environ.get('CONFIGPROXY_AUTH_TOKEN')
c.ConfigurableHTTPProxy.debug=True
# redirect all standard port http connections
c.ConfigurableHTTPProxy.command = ['configurable-http-proxy', '--redirect-port', '80']
# for dev. most detailed logs
c.JupyterHub.log_level = 0

# ip and port config

# listen on all interfaces
c.JupyterHub.hub_ip = '0.0.0.0'
# access hub by container name on the Docker network. 
# this is set automatically with above setting. uncomment if hub_ip changes
#c.JupyterHub.hub_connect_ip = os.environ.get('HUB_CONTAINER_NAME')
# Jupyterhub port. proxy redirects to this port
c.JupyterHub.hub_port = 8080

# TLS config

#c.JupyterHub.ip = '*'
c.JupyterHub.port = 443
c.JupyterHub.ssl_key = os.environ.get('SSL_KEY')
c.JupyterHub.ssl_cert = os.environ.get('SSL_CERT')
# TODO: config ssl_certs volume and other for this setting
#c.JupyterHub.internal_ssl=True

# User Authentication

# TODO: Configure Oath (via GitLab?) for more robust authentication
# Authenticate users with GitHub OAuth if you whish to do that I have a local authentication
#c.JupyterHub.authenticator_class = 'oauthenticator.GitHubOAuthenticator'
#c.GitHubOAuthenticator.oauth_callback_url = 'https://your_ip_addrees/hub/oauth_callback'
#c.GitHubOAuthenticator.client_id = '---­­­­­­­Some cryptic string----­­­­­'
#c.GitHubOAuthenticator.client_secret = '---­­­­­­­Some cryptic string----­­­­­'

# using nativeauthenticator from: https://native-authenticator.readthedocs.io/en/latest/quickstart.html
c.JupyterHub.authenticator_class = 'nativeauthenticator.NativeAuthenticator'
# NOTE: only for testing. allows open signin with no confirmation
c.Authenticator.open_signup = True
# catch and prevent common, weak passwords
c.Authenticator.check_common_password = True
c.Authenticator.minimum_password_length = 10
# prevent excessive login attempts. user would have to contact admin
c.Authenticator.allowed_failed_logins = 5
cookie_secret = os.environ.get('CONFIGPROXY_AUTH_TOKEN')
# bytes.fromhex will break if hex string has odd length. append leading zero if this is the case
if (len(cookie_secret) % 2) == 1: cookie_secret = '0' + cookie_secret 
c.JupyterHub.cookie_secret = bytes.fromhex(cookie_secret) 

# Server and User setup

# allow named servers so users can run mult servers at once possibly with different configs
c.JupyterHub.allow_named_servers = True
# limit amount of servers users can run
c.JupyterHub.named_server_limit_per_user = int(os.environ.get('USR_NAMED_SRV_LIM'))
# by default redirect users from /hub to /hub/home where named servers are managed
# instead of automatically redirecting a user's default server
c.JupyterHub.redirect_to_server = False
# configures whether admins can login to nOtebook servers owned by other users
# set to True for debugging purposes
c.JupyterHub.admin_access = False

# Set up a userlist file with usernames and roles
c.Authenticator.whitelist = whitelist = set()
c.Authenticator.admin_users = admins = set()
pwd = os.path.dirname(__file__)
# volumes where each user has a dir
user_env_vars = ['WORK', 'ENV']
user_vol_dirs = dict()
volumes = dict()
for var in user_env_vars: user_vol_dirs[var] = os.environ.get("USER_{var}_DIR".format(var=var))
with open(os.path.join(pwd, 'userlist')) as f:
    
    # spawn docker client to create volumes below
    import docker
    client = docker.DockerClient(base_url='unix://var/run/docker.sock')
    volume_driver = os.environ.get('HUB_VOL_DRIVER')

    for line in f:
        # ignore newlines
        if not line:
            continue
        user_role = line.split()
        user = user_role[0]
        whitelist.add(user)
        if len(user_role) > 1 and user_role[1] == 'admin':
            admins.add(user)
        
        # template name for user dirs
        hub_user_dir = "jupyterhub-user-{user}".format(user=user)

        # create dirs for users in userlists 
        # and use them as mountpoints for docker volumes
        for var in user_env_vars:
            # volume mountpoint in hub container 
            user_vol_dir = user_vol_dirs[var] 
            user_dir = os.path.join(user_vol_dir, hub_user_dir) 
            if var == 'WORK':
                hub_user_data_dir = os.path.join(user_dir, 'my_data')
                os.makedirs(hub_user_data_dir, exist_ok=True)
            else:
                os.makedirs(user_dir, exist_ok=True)
        
            # save data to create volumes for user dirs down below
            # necessary to use this driver so data created in container
            # appears in host (physical server)
            vol_name = "{dir}-{var}".format(dir=hub_user_dir, var=var.lower())
            volumes[vol_name] = user_dir
            client.volumes.create(
                name=vol_name,
                driver=volume_driver,
                driveropts={'mountpoint': volumes[vol_name]}
            )

# Database connection setup

c.JupyterHub.db_url='postgresql://postgres:{password}@{host}/{db}'.format(
    host = os.environ.get('POSTGRES_HOST'), 
    password = os.environ.get('POSTGRES_PASSWORD'),
    db = os.environ.get('POSTGRES_DB'),
)


# DockerSpawner config. 

# config docs only available through source: 
# https://github.com/jupyterhub/dockerspawner/blob/master/dockerspawner/dockerspawner.py

# Spawn single-user servers as Docker containers
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
# disable user notebook config so we can use nb2kg 
c.Spawner.disable_user_config = True 
# Remove containers once they are stopped
c.DockerSpawner.remove_containers = True
# For debugging arguments passed to spawned containers
c.DockerSpawner.debug = True
# Spawn containers from this image
c.DockerSpawner.image = os.environ.get('DOCKER_NOTEBOOK_IMAGE')
# JupyterHub requires a single-user instance of the Notebook server, so we
# default to using the `start-singleuser.sh` script included in the
# jupyter/docker-stacks *-notebook images as the Docker run command when
# spawning containers.  Optionally, you can override the Docker run command
# using the DOCKER_SPAWN_CMD environment variable.
# NOTE: second argument is default CMD if env var dne
spawn_cmd = os.environ.get('DOCKER_SPAWN_CMD')
c.Spawner.cmd = spawn_cmd
# NOTE: Add Nvidia and other relevant env vars if nec.
c.DockerSpawner.extra_create_kwargs = {'command': spawn_cmd, 'volumes': {}}
# Connect containers to this Docker network
network_name = os.environ.get('DOCKER_NETWORK_NAME')
# enables usage of internal docker ip. 
c.DockerSpawner.network_name = network_name
# Pass the network name as argument to spawned containers
# useful for when hub container and user containers are within the same docker network 
c.DockerSpawner.use_internal_ip = True
c.DockerSpawner.use_internal_hostname = True
c.Spawner.env_keep = ['JUPYTER_ENABLE_LAB']


# Persist hub and user data via volume binds

#hub_data_dir = os.environ.get('HUB_DATA_DIR', '/srv/jupyterhub')
# Explicitly set notebook directory because we'll be mounting a host volume to
# it.  Most jupyter/docker-stacks *-notebook images run the Notebook server as
# user `jovyan`, and set the notebook directory to `/home/jovyan/work`.
notebook_dir= os.environ.get('DOCKER_NOTEBOOK_DIR') or '/home/jovyan/'
c.Spawner.notebook_dir= notebook_dir

# template for user dirs as source for docker volume 
# bind on nb server spawn 
dir_template = 'jupyterhub-user-{username}'
# join dir_template to all user docker volume mountpoint paths 
# 1. hub host bind source for notebook_dir
# 2. hub host bind for user conda envs (used to persistently install 
# new pkgs and libs inside docker containers)
# 3. hub host bind for user jupyter kernels 
# (used to run python env w. user installed pkgs and libs)
# 4. hub host bind for user data (datasets, images, etc.)
# 5. hub host bind source for global data
nb_dir = dir_template + '-work'
envs_dir = dir_template + '-envs'
kernels_dir = os.environ.get('USER_KERNELS_DIR')
global_data_dir = os.environ.get('GLOBAL_DATA_DIR')

# create volumes for kernels

client.volumes.create(
    name='nb_kernels',
    driver=volume_driver,
    driveropts={'mountpoint': kernels_dir}
)

# nb container bind targets
docker_nb_dir = notebook_dir
# TODO: replace this hardcoded value w. env var 
docker_envs_dir = '/opt/conda/envs'
docker_kernels_dir = kernels_dir
docker_global_data_dir = os.path.join(notebook_dir, 'global_data')

c.DockerSpawner.volumes = {
    nb_dir : {"bind": docker_nb_dir, "mode":"rw"},
    envs_dir: {"bind": docker_envs_dir, "mode": "rw"},
    kernels_dir: {"bind": docker_kernels_dir, "mode": "rw"},
    global_data_dir: {"bind": docker_global_data_dir, "mode": "ro"}
}

# runtime used for spawned notebooks
runtime = os.environ.get('SPAWN_RUNTIME')
# see host_config parameters here: https://docker-py.readthedocs.io/en/stable/containers.html
# more docs here: https://docker-py.readthedocs.io/en/1.8.0/hostconfig/
c.DockerSpawner.extra_host_config = {
    'network_mode': network_name,
    'volume_driver': 'local',
    'runtime': runtime 
}
