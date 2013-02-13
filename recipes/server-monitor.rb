#
# Cookbook Name:: serverdensity
# Recipe:: server-monitor

# Install the server monitor
package "sd-agent" do
  action :install
end

# Configure your Server Density agent key
template "/etc/sd-agent/config.cfg" do
  source "config.cfg.erb"
  owner "root"
  group "root"
  mode "644"
  variables(node[:serverdensity])
  notifies :restart, "service[sd-agent]"
end

service "sd-agent" do
  supports :start => true, :stop => true, :restart => true
  # Starts the service if it's not running and enables it to start at system boot time
  action [:enable, :start]
end
