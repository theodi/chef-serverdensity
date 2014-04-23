#
# Cookbook Name:: serverdensity
# Resource:: plugin

actions :enable, :disable
default_action :enable

# plugin name
attribute :name,
  :kind_of => String,
  :name_attribute => true

# plugin specific settings
attribute :config,
  :kind_of => Hash,
  :default => Hash.new

# path to plugin file
attribute :path,
  :kind_of => String,
  :required => true
