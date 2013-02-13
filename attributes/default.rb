#
# Cookbook Name:: serverdensity
# Attributes:: default

default.serverdensity.repository_key = "boxedice-public"

default.serverdensity.agent_key = "CHANGE_ME"
default.serverdensity.sd_url = "CHANGE_ME"

###################
# Advanced config #
###################

default.serverdensity.plugin_dir = ""

# Set this to enable Apache monitoring
default.serverdensity.apache_status_url = nil
default.serverdensity.apache_status_user = "CHANGE_ME"
default.serverdensity.apache_status_user = "CHANGE_ME"

# Set this to enable MongoDB monitoring
default.serverdensity.mongodb_server = nil
default.serverdensity.mongodb_dbstats = false
default.serverdensity.mongodb_replset = false

# Set this to enable MySQL monitoring
default.serverdensity.mysql_server = nil
default.serverdensity.mysql_user = "CHANGE_ME"
default.serverdensity.mysql_pass = "CHANGE_ME"

# Set this to enable nginx monitoring
default.serverdensity.nginx_status_url = nil

# Set this to enable RabbitMQ monitoring
default.serverdensity.rabbitmq_status_url = nil
# Will default to guest
default.serverdensity.rabbitmq_user = nil
# Will default to guest
default.serverdensity.rabbitmq_pass = nil

# temp directory location, otherwise system default is used if not set
default.serverdensity.tmp_directory = nil

# PID file directory, otherwise stored in temp if not set
default.serverdensity.pidfile_directory = nil

# Logging level, defaults to INFO if not set
defaults.serverdensity.logging_level = nil
