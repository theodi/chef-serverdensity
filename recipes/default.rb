#
# Cookbook Name:: serverdensity
# Recipe:: default

include_recipe "serverdensity::install"
include_recipe "serverdensity::server-monitor"
