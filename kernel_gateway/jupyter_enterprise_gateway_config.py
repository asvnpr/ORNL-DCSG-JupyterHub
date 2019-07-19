import os
import ast

c = get_config()
# Configuration file for jupyter-enterprise-gateway.

#------------------------------------------------------------------------------
# Application(SingletonConfigurable) configuration
#------------------------------------------------------------------------------

## This is an application.

## The date format used by logging formatters for %(asctime)s
c.Application.log_datefmt = '%Y-%m-%d %H:%M:%S'

## The Logging format template
#c.Application.log_format = '[%(name)s]%(highlevel)s %(message)s'

## Set the log level by value or name.
c.Application.log_level = 0

#------------------------------------------------------------------------------
# JupyterApp(Application) configuration
#------------------------------------------------------------------------------

## Base class for Jupyter applications

## Answer yes to any prompts.
#c.JupyterApp.answer_yes = False

## Full path of a config file.
#c.JupyterApp.config_file = ''

## Specify a config file to load.
#c.JupyterApp.config_file_name = ''

## Generate default config file.
#c.JupyterApp.generate_config = False

#------------------------------------------------------------------------------
# KernelGatewayApp(JupyterApp) configuration
#------------------------------------------------------------------------------

## Application that provisions Jupyter kernels and proxies HTTP/Websocket traffic
#  to the kernels.
#  
#  - reads command line and environment variable settings - initializes managers
#  and routes - creates a Tornado HTTP server - starts the Tornado event loop

## Sets the Access-Control-Allow-Credentials header. (KG_ALLOW_CREDENTIALS env
#  var)
#c.KernelGatewayApp.allow_credentials = ''

## Sets the Access-Control-Allow-Headers header. (KG_ALLOW_HEADERS env var)
#c.KernelGatewayApp.allow_headers = ''

## Sets the Access-Control-Allow-Methods header. (KG_ALLOW_METHODS env var)
#c.KernelGatewayApp.allow_methods = ''

## Sets the Access-Control-Allow-Origin header. (KG_ALLOW_ORIGIN env var)
#c.KernelGatewayApp.allow_origin = ''

## Controls which API to expose, that of a Jupyter notebook server, the seed
#  notebook's, or one provided by another module, respectively using values
#  'kernel_gateway.jupyter_websocket', 'kernel_gateway.notebook_http', or another
#  fully qualified module name (KG_API env var)
c.KernelGatewayApp.api = 'kernel_gateway.jupyter_websocket'
# set through kg.env
## Authorization token required for all requests (KG_AUTH_TOKEN env var)
#c.KernelGatewayApp.auth_token = os.getenv('KG_AUTH_TOKEN')

## The base path for mounting all API resources (KG_BASE_URL env var)
#c.KernelGatewayApp.base_url = '/'

## The full path to an SSL/TLS certificate file. (KG_CERTFILE env var)
#c.KernelGatewayApp.certfile = None

## The full path to a certificate authority certificate for SSL/TLS client
#  authentication. (KG_CLIENT_CA env var)
#c.KernelGatewayApp.client_ca = None

## Default kernel name when spawning a kernel (KG_DEFAULT_KERNEL_NAME env var)
#c.KernelGatewayApp.default_kernel_name = ''

## Environment variables allowed to be inherited from the spawning process by the
#  kernel
#c.KernelGatewayApp.env_process_whitelist = []

## Sets the Access-Control-Expose-Headers header. (KG_EXPOSE_HEADERS env var)
#c.KernelGatewayApp.expose_headers = ''

## Override any kernel name specified in a notebook or request
#  (KG_FORCE_KERNEL_NAME env var)
#c.KernelGatewayApp.force_kernel_name = ''

## IP address on which to listen (KG_IP env var)
c.KernelGatewayApp.ip = os.getenv('KG_IP')

## The kernel manager class to use.
## manages remote kernels via process-proxy
#c.KernelGatewayApp.kernel_manager_class = 'kernel_gateway.kernels.remotemanager.RemoteMappingKernelManager'
#print("Using kernel_manager_class: {}".format(c.KernelGatewayApp.kernel_manager_class))

## The kernel spec manager class to use. Should be a subclass of
#  `jupyter_client.kernelspec.KernelSpecManager`.
#c.KernelGatewayApp.kernel_spec_manager_class = 'jupyter_client.kernelspec.KernelSpecManager'

## The full path to a private key file for usage with SSL/TLS. (KG_KEYFILE env
#  var)
#c.KernelGatewayApp.keyfile = None

## Sets the Access-Control-Max-Age header. (KG_MAX_AGE env var)
#c.KernelGatewayApp.max_age = ''

## Limits the number of kernel instances allowed to run by this gateway.
#  Unbounded by default. (KG_MAX_KERNELS env var)
#c.KernelGatewayApp.max_kernels = None

## Port on which to listen (KG_PORT env var)
c.KernelGatewayApp.port = int(os.getenv('KG_PORT', 9889))

## Number of ports to try if the specified port is not available (KG_PORT_RETRIES
#  env var)
#c.KernelGatewayApp.port_retries = 50

## Number of kernels to prespawn using the default language. No prespawn by
#  default. (KG_PRESPAWN_COUNT env var)
#c.KernelGatewayApp.prespawn_count = None

## Runs the notebook (.ipynb) at the given URI on every kernel launched. No seed
#  by default. (KG_SEED_URI env var)
#c.KernelGatewayApp.seed_uri = None

## Use x-* header values for overriding the remote-ip, useful when application is
#  behing a proxy. (KG_TRUST_XHEADERS env var)
#c.KernelGatewayApp.trust_xheaders = False

#------------------------------------------------------------------------------
# EnterpriseGatewayApp(KernelGatewayApp) configuration
#------------------------------------------------------------------------------

## Application that provisions Jupyter kernels and proxies HTTP/Websocket traffic
#  to the kernels.
#  
#  - reads command line and environment variable settings - initializes managers
#  and routes - creates a Tornado HTTP server - starts the Tornado event loop

## The http url specifying the alternate YARN Resource Manager.  This value
#  should be set when YARN Resource Managers are configured for high
#  availability.  Note: If both YARN endpoints are NOT set, the YARN library will
#  use the files within the local HADOOP_CONFIG_DIR to determine the active
#  resource manager. (EG_ALT_YARN_ENDPOINT env var)
#c.EnterpriseGatewayApp.alt_yarn_endpoint = None

## Comma-separated list of user names (e.g., ['bob','alice']) against which
#  KERNEL_USERNAME will be compared.  Any match (case-sensitive) will allow the
#  kernel's launch, otherwise an HTTP 403 (Forbidden) error will be raised.  The
#  set of unauthorized users takes precedence. This option should be used
#  carefully as it can dramatically limit who can launch kernels.
#  (EG_AUTHORIZED_USERS env var - non-bracketed, just comma-separated)
#auth_users = os.getenv('EG_AUTHORIZED_USERS', "['jovyan']")
# convert str representation of list to actual list
#auth_users = ast.literal_eval(auth_users)
#c.EnterpriseGatewayApp.authorized_users = set(auth_users)

## The http url for accessing the Conductor REST API. (EG_CONDUCTOR_ENDPOINT env
#  var)
#c.EnterpriseGatewayApp.conductor_endpoint = None

## Indicates whether impersonation will be performed during kernel launch.
#  (EG_IMPERSONATION_ENABLED env var)
#c.EnterpriseGatewayApp.impersonation_enabled = bool(os.getenv('EG_IMPERSONATION_ENABLED'))

## The kernel manager class to use. Must be a subclass of
#  `notebook.services.kernels.MappingKernelManager`. default: 
#c.EnterpriseGatewayApp.kernel_manager_class = 'enterprise_gateway.services.kernels.remotemanager.RemoteMappingKernelManager'

## The kernel session manager class to use. Must be a subclass of
#  `enterprise_gateway.services.sessions.KernelSessionManager`. default:
c.EnterpriseGatewayApp.kernel_session_manager_class = 'enterprise_gateway.services.sessions.kernelsessionmanager.FileKernelSessionManager'

## The kernel spec manager class to use. Must be a subclass of
#  `jupyter_client.kernelspec.KernelSpecManager`.
#c.EnterpriseGatewayApp.kernel_spec_manager_class = 'jupyter_client.kernelspec.KernelSpecManager'

# set through kg.env
## Specifies the maximum number of kernels a user can have active simultaneously.
#  A value of -1 disables enforcement. (EG_MAX_KERNELS_PER_USER env var)
#c.EnterpriseGatewayApp.max_kernels_per_user = -1

# set through kg.env
## Specifies the lower and upper port numbers from which ports are created. The
#  bounded values are separated by '..' (e.g., 33245..34245 specifies a range of
#  1000 ports to be randomly selected). A range of zero (e.g., 33245..33245 or
#  0..0) disables port-range enforcement.  (EG_PORT_RANGE env var)
#c.EnterpriseGatewayApp.port_range = '0..0'

## Bracketed comma-separated list of hosts on which DistributedProcessProxy
#  kernels will be launched e.g., ['host1','host2']. (EG_REMOTE_HOSTS env var -
#  non-bracketed, just comma-separated)
#c.EnterpriseGatewayApp.remote_hosts = ['localhost']

## Comma-separated list of user names (e.g., ['root','admin']) against which
#  KERNEL_USERNAME will be compared.  Any match (case-sensitive) will prevent the
#  kernel's launch and result in an HTTP 403 (Forbidden) error.
#  (EG_UNAUTHORIZED_USERS env var - non-bracketed, just comma-separated)
#c.EnterpriseGatewayApp.unauthorized_users = {'root'}

## The http url specifying the YARN Resource Manager. Note: If this value is NOT
#  set, the YARN library will use the files within the local HADOOP_CONFIG_DIR to
#  determine the active resource manager. (EG_YARN_ENDPOINT env var)
#c.EnterpriseGatewayApp.yarn_endpoint = None

## Is YARN Kerberos/SPNEGO Security enabled (True/False).
#  (EG_YARN_ENDPOINT_SECURITY_ENABLED env var)
#c.EnterpriseGatewayApp.yarn_endpoint_security_enabled = False

#------------------------------------------------------------------------------
# NotebookHTTPPersonality(LoggingConfigurable) configuration
#------------------------------------------------------------------------------

## Personality for notebook-http support, creating REST endpoints based on the
#  notebook's annotated cells

## Optional API to download the notebook source code in notebook-http mode,
#  defaults to not allow
#c.NotebookHTTPPersonality.allow_notebook_download = False

## Determines which module is used to parse the notebook for endpoints and
#  documentation. Valid module names include
#  'kernel_gateway.notebook_http.cell.parser' and
#  'kernel_gateway.notebook_http.swagger.parser'. (KG_CELL_PARSER env var)
#c.NotebookHTTPPersonality.cell_parser = 'kernel_gateway.notebook_http.cell.parser'

## Maps kernel language to code comment syntax
#c.NotebookHTTPPersonality.comment_prefix = {'scala': '//', None: '#'}

## Serve static files on disk in the given path as /public, defaults to not serve
#c.NotebookHTTPPersonality.static_path = None

#------------------------------------------------------------------------------
# JupyterWebsocketPersonality(LoggingConfigurable) configuration
#------------------------------------------------------------------------------

## Personality for standard websocket functionality, registering endpoints that
#  are part of the Jupyter Kernel Gateway API

## Environment variables allowed to be set when a client requests a new kernel
#c.JupyterWebsocketPersonality.env_whitelist = []

## Permits listing of the RUNNING kernels using API endpoints /api/kernels and
#  /api/sessions (KG_LIST_KERNELS env var). Note: Jupyter Notebook allows this by
#  default but kernel gateway does not.
#c.JupyterWebsocketPersonality.list_kernels = True
