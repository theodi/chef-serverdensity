#
# Cookbook Name:: serverdensity
# Attributes:: default

default['serverdensity']['agent_key'] = "CHANGE_ME"
default['serverdensity']['sd_url'] = "CHANGE_ME"

###################
# Advanced config #
###################

# Only change this to a path if you want plugins, will be ignored otherwise
default['serverdensity']['plugin_dir'] = ""

# Set this to enable Apache monitoring
default['serverdensity']['apache_status_url'] = nil
# Change apache_status_user if you set apache_status_url above
default['serverdensity']['apache_status_user'] = ""
# Change apache_status_pass if you set apache_status_url above
default['serverdensity']['apache_status_pass'] = ""

# Set this to enable MongoDB monitoring
default['serverdensity']['mongodb_server'] = nil
default['serverdensity']['mongodb_dbstats'] = false
default['serverdensity']['mongodb_replset'] = false

# Set this to enable MySQL monitoring
default['serverdensity']['mysql_server'] = nil
# Change mysql_user if you set mysql_server above
default['serverdensity']['mysql_user'] = ""
# Change mysql_pass if you set mysql_server above
default['serverdensity']['mysql_pass'] = ""

# Set this to enable nginx monitoring
default['serverdensity']['nginx_status_url'] = nil

# Set this to enable RabbitMQ monitoring
default['serverdensity']['rabbitmq_status_url'] = nil
# Will default['to guest
default['serverdensity']['rabbitmq_user'] = nil
# Will default['to guest
default['serverdensity']['rabbitmq_pass'] = nil

# temp directory location, otherwise system default['is used if not set
default['serverdensity']['tmp_directory'] = nil

# PID file directory, otherwise stored in temp if not set
default['serverdensity']['pidfile_directory'] = nil

# Logging level, default[' to INFO if not set
default['.serverdensity']['logging_level'] = nil
