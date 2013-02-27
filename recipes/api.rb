# ex: set tabstop=2 shiftwidth=2 expandtab:
#
# Cookbook Name:: serverdensity
# Recipe:: api
#
# Get or create a device for the current hostname using the Server Density API

require 'uri'
require 'chef/log'
require 'rest_client'

api_version = node['serverdensity']['api_version']
account_name = node['serverdensity']['sd_url'].sub(/^https?:\/\//, "")

Chef::Log.info("No agent key defined, querying Server Density API v#{ api_version } for host '#{ node[:hostname] }'")

def group(node)
    if node['serverdensity']['device_group']
      node['serverdensity']['device_group']
    else
      'chef-autodeploy'
    end
end

case Float(api_version)

when 1..2

  if node['serverdensity']['api_username'].nil?
    Chef::Log.fatal("No Server Density api_username set, either set this or set agent_key")
    exit 1
  end
  if node['serverdensity']['api_password'].nil?
    Chef::Log.fatal("No Server Density api_password set, either set this or set agent_key")
    exit 1
  end

  base_url = "#{ node['serverdensity']['api_v1_base_url'] }#{ api_version }/"
  base_url = base_url.sub "://", "://#{ URI::escape(node['serverdensity']['api_username']) }:#{ URI::escape(node['serverdensity']['api_password']) }@"

  begin
    query = {
      :hostname => node[:hostname],
      :account => account_name
    }
    device = Chef::JSONCompat.from_json(RestClient.get("#{ base_url }devices/getByHostName", :params => query))
  rescue => e
    device = Chef::JSONCompat.from_json(e.response)
  end

  if device['status'] == 2
    Chef::Log.info("Couldn't find device, creating a new one")

    # Create new device
    data = {
      :name => node.name,
      :hostName => node[:hostname],
      :notes => 'Created automatically by chef-serverdensity',
      :group => group(node)
    }

    begin
      device = Chef::JSONCompat.from_json(RestClient.post("#{ base_url }devices/add?account=#{ account_name }", data))
    rescue => e
      Chef::Log.fatal("Unable to create device: #{ e.response }")
      exit 1
    end

  elsif device.code != 200
    Chef::Log.fatal("Unable to query for device: #{ device }")
    exit 1
  end

  agent_key = device['data']['agentKey']

when 2..3
  
  tokens = node['serverdensity']['api_v2_token']

  if token.nil?
    Chef::Log.fatal("No Server Density OAuth2 token (api_v2_token) set, either set this or set agent_key")
    exit 1
  end

  base_url = "#{ node['serverdensity']['api_v2_base_url'] }/"
  filter = {
    :type => 'device',
    :hostname => node[:hostname]
  }

  begin
    query = {
      :filter => Chef::JSONCompat.to_json(filter),
      :token => token
    }
    devices = Chef::JSONCompat.from_json(RestClient.get("#{ base_url }inventory/resources/", :params => query))
  rescue => e
    Chef::Log.fatal("Unable to query for device: #{ e.response }")
    exit 1
  end

  if devices.length == 0
    Chef::Log.info("Couldn't find device, creating a new one")

    # Create new device
    data = {
      'name' => node[:node_name],
      'hostname' => node[:hostname],
      'group' => group(node)
    }

    begin
      device = Chef::JSONCompat.from_json(RestClient.post("#{ base_url }inventory/devices/?token=#{ token }", data))
    rescue => e
      Chef::Log.fatal("Unable to create device: #{ e.response }")
      exit 1
    end

  else
    device = devices[0]
  end

  agent_key = device['agentKey']

end

Chef::Log.info("Using agent key '#{ agent_key }'")

node.set['serverdensity']['agent_key'] = agent_key
