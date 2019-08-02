#! /usr/bin/env python3

import argparse
import json
import subprocess
from os import path, environ, getcwd
from sys import exit
import conda_pack
from ipykernel import kernelspec
import shutil

kernel_template = {
    "language": "",
    "display_name": "",
    "metadata": {
        "process_proxy": {
            "class_name": "",
            "config": {
                "image_name": ""
            }
        }
    },
    "env": {
    },
    "argv": [
        "python",
        "",
        "--RemoteProcessProxy.kernel-id",
        "{kernel_id}",
        "--RemoteProcessProxy.response-address",
        "{response_address}"
    ]
}

def create_kernel(kernel, env, lang, proc, img, cmd):
    tmp_install = kernelspec.install(kernel_name=env, display_name=kernel, prefix='/tmp/')

    kernel_template['language'] = lang
    kernel_template['metadata']['process_proxy']['class_name'] = proc
    kernel_template['metadata']['process_proxy']['config']['image_name'] = img
    kernel_template['env']['KERNEL_USERNAME'] = environ.get('KERNEL_USERNAME')
    kernel_template['env']['KERNEL_ENV'] = env
    kernel_template['argv'][1] = cmd

    tmp_kernel = path.join(tmp_install, 'kernel.json')
    # write our modified kernel to our temp dir
    with open(tmp_kernel, 'w') as k:
        k.write(json.dumps(tmp_kernel))
    install_out = subprocess.check_output(["/opt/conda/bin/jupyter", "kernelspec", "install", "--prefix=/opt/conda", tmp_install])

    src = '/opt/conda/share/jupyter/kernels/python_tf_gpu_docker/scripts'
    dst = '/opt/conda/share/jupyter/kernels/{env}/scripts'.format(env=env)
    try:
        shutil.copytree(src, dst)
    except OSError as e:
        print(e)
        raise e

def env_pack(env, path=False):
    if path:
        path = env.split('/')
        env = path[-1]
        prefix = path[:-1]
        conda.pack(name=env, prefix=prefix)
    else:
        conda.pack(name=env)


if __name__ == '__main__':
    desc = """Script to create Jupyter remote kernels for the Jupyter Enterprise Gateway
    from an existing conda environment. This scripts takes care of the extra parameters
    in the kernel.json and placing it in the appropriate directory so it appears on the
    kernel gateway and the list of available kernels. """



    parser = argparse.ArgumentParser(description=desc)
    gp = parser.add_mutually_exclusive_group(required=True)
    parser.add_argument('-k', '--kernel-name', dest='kernel', help='The kernel name displayed in Jupyter. Default: "(<user>) <env-name>"', default='')
    gp.add_argument('-e', '--env-name', dest='env', required=True, help='conda env to install as kernel', default='')
    gp.add_argument('-p', '--env-path', dest='path', required=True, help='conda env to install as kernel', default='')
    # get dict of parsed args and their values
    args = parser.parse_args()

    env_name = args['env']
    env_path = args['path']
    kernel_name = args['kernel']
    # default values, but leave as vars for potential future use in other langs, clusters or other setups
    kernel_lang = 'python'
    eg_process_class = 'enterprise_gateway.services.processproxies.docker_swarm.DockerProcessProxy'
    base_kernel_image = 'hub-kernel'
    conda_dir = environ.get('CONDA_DIR', '/opt/conda')
    script_cmd = "/{conda}/share/jupyter/kernels/{env}/scripts/launch_docker.py"

    if env_name and path.exists(path.join(conda_dir, 'envs', env_name)):
        # if no kernel name is provided use default
        if not kernel_name:
            user = environ.get('KERNEL_USERNAME')
            kernel_name = "({user} Python 3: {env})".format(user=user, env=env_name)
        script_cmd = script_cmd.format(conda=conda_dir, env=env_name)
        env_pack(env=env_name)
        create_kernel(kernel=kernel_name, env=env_name, lang=kernel_lang, proc=eg_process_class, img=base_kernel_image, cmd=script_cmd)
    elif env_path and (path.exists(path) or path.exists(path.join(getcwd(), path)):
        # if no kernel name is provided use default
        if not kernel_name:
            user = environ.get('KERNEL_USERNAME')
            kernel_name = "({user} Python 3: {env})".format(user=user, env=env_name)
        env_pack(env=env_path, True)
        env_name = env_path.split('/')[-1]
        script_cmd = script_cmd.format(conda=conda_dir, env=env_name)
        create_kernel(kernel=kernel_name, env=env_name, lang=kernel_lang, proc=eg_process_class, img=base_kernel_image, cmd=script_cmd)
    else:
        print('ERROR! There is an error with the provided env name.\n' + \
            'Check that the env file or path exists!')
        exit(1)
