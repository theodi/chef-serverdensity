#
# Cookbook Name:: serverdensity
# Recipe:: default

include_recipe 'serverdensity::install'

serverdensity_api
serverdensity_agent node.name

serverdensity_alert do
  type :group
end
