#
# Cookbook Name:: serverdensity
# Attributes:: default

# Set this to your account subdomain i.e. https://companyname.serverdensity.io
default['serverdensity']['sd_url'] = "CHANGE_ME"

# You must set agent_key unless you want to use the API to query by hostname
# or create a new device if not found (see below)
default['serverdensity']['agent_key'] = nil

# Set this to false on servers you do not wish to monitor
default['serverdensity']['enabled'] = true

##############################
# API config (optional)      #
##############################

# These attributes are provided for convenience, but it is better to use
# the serverdensity LWRP to set these values

# To use SD v2, set this to your API token
default['serverdensity']['token'] = nil

# To use SD v1, set these to your username and password
default['serverdensity']['username'] = nil
default['serverdensity']['password'] = nil

##############################
# Advanced config (optional) #
##############################

# Server Density group server should belong to (requires API)
default['serverdensity']['device_group'] = nil

# Only change this to a path if you want plugins, will be ignored otherwise
default['serverdensity']['plugin_dir'] = ""

# Set this to enable Apache monitoring
default['serverdensity']['apache_status_url'] = nil
default['serverdensity']['apache_status_user'] = ""
default['serverdensity']['apache_status_pass'] = ""

# Set this to enable MongoDB monitoring
default['serverdensity']['mongodb_server'] = nil
default['serverdensity']['mongodb_dbstats'] = false
default['serverdensity']['mongodb_replset'] = false

# Set this to enable MySQL monitoring
default['serverdensity']['mysql_server'] = nil
default['serverdensity']['mysql_user'] = ""
default['serverdensity']['mysql_pass'] = ""

# Set this to enable nginx monitoring
default['serverdensity']['nginx_status_url'] = nil

# Set this to enable RabbitMQ monitoring
default['serverdensity']['rabbitmq_status_url'] = nil
default['serverdensity']['rabbitmq_user'] = nil
default['serverdensity']['rabbitmq_pass'] = nil

# temp directory location, otherwise system default is used if not set
default['serverdensity']['tmp_directory'] = nil

# PID file directory, otherwise stored in temp if not set
default['serverdensity']['pidfile_directory'] = nil

# Logging level, default[' to INFO if not set
default['serverdensity']['logging_level'] = nil

# If you want to configure any plugin options add them here
default['serverdensity']['plugin_options'] = {}
