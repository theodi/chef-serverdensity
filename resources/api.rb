#
# Cookbook Name:: serverdensity
# Resource:: api

actions :configure
default_action :configure

# server name
attribute :name,
  :kind_of => String,
  :name_attribute => true,
  :required => true

# apiv1 credentials
attribute :account,
  :kind_of => String,
  :default => node.serverdensity.sd_url.sub(/^https?:\/\//, "")
attribute :username,
  :kind_of => String,
  :default => node.serverdensity.username
attribute :password,
  :kind_of => String,
  :default => node.serverdensity.password

# apiv2 token
attribute :token,
  :kind_of => String,
  :default => node.serverdensity.token
