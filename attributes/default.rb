#
# Cookbook Name:: serverdensity
# Attributes:: default

default['serverdensity']['sd_url'] = nil
default['serverdensity']['agent_key'] = nil
default['serverdensity']['enabled'] = true

default['serverdensity']['token'] = nil
default['serverdensity']['username'] = nil
default['serverdensity']['password'] = nil

default['serverdensity']['device_group'] = nil

default['serverdensity']['plugin_dir'] = nil
default['serverdensity']['plugin_options'] = {}

default['serverdensity']['apache_status_url'] = nil
default['serverdensity']['apache_status_user'] = nil
default['serverdensity']['apache_status_pass'] = nil

default['serverdensity']['mongodb_server'] = nil
default['serverdensity']['mongodb_dbstats'] = false
default['serverdensity']['mongodb_replset'] = false

default['serverdensity']['mysql_server'] = nil
default['serverdensity']['mysql_user'] = nil
default['serverdensity']['mysql_pass'] = nil

default['serverdensity']['nginx_status_url'] = nil

default['serverdensity']['rabbitmq_status_url'] = nil
default['serverdensity']['rabbitmq_user'] = nil
default['serverdensity']['rabbitmq_pass'] = nil

default['serverdensity']['tmp_directory'] = nil
default['serverdensity']['pidfile_directory'] = nil

default['serverdensity']['logging_level'] = nil

default['serverdensity']['alerts'] = []
