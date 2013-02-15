# ex: set tabstop=2 shiftwidth=2 expandtab:
#
# Cookbook Name:: serverdensity
# Recipe:: api
#
# Get or create a device for the current hostname using the Server Density API

require 'open-uri'
require 'chef/log'
require 'chef/rest'
require 'chef/json_compat'

api_version = node['serverdensity']['api_version']

Chef::Log.info("No agent key defined, querying Server Density API v#{ api_version } for host '#{ node[:hostname] }'")

def group(node)
    if node['serverdensity']['device_group']
      node['serverdensity']['device_group']
    else
      'chef'
    end
end

def form_encode(data)
    parts = []
    data.each_pair do |name, value|
      parts.push(URI::encode("#{ name }=#{ value }"))
    end
    parts.join("&")
end

case Float(api_version)

when 1..2

  if node['serverdensity']['api_username'].nil?
    Chef::Log.fatal("No Server Density api_username set, either set this or set agent_key")
  end
  if node['serverdensity']['api_password'].nil?
    Chef::Log.fatal("No Server Density api_password set, either set this or set agent_key")
  end

  base_url = "#{ node['serverdensity']['api_v1_base_url'] }#{ api_version }/"
  headers = {
    "Authorization" => "Basic #{ node['serverdensity']['api_username'] }:#{ node['serverdensity']['api_password'] }"
  }
  client = Chef::REST::RESTRequest.new("GET", "#{ base_url }devices/getByHostName?hostName=#{ node[:hostname] }", nil, headers)
  response = client.call {|r| r.read_body}
  device = Chef::JSONCompat.from_json(response.body.chomp)

  if device['status'] == 2
    Chef::Log.info("Couldn't find device, creating a new one")

    # Create new device
    data = {
      'name' => node[:node_name],
      'hostName' => node[:hostname],
      'notes' => 'Created automatically by chef-serverdensity',
      'group' => group(node)
    }

    client = Chef::REST::RESTRequest.new("POST", "#{ base_url }devices/add", form_encode(data), headers)
    response = client.call {|r| r.read_body}
    device = Chef::JSONCompat.from_json(response.body.chomp)
  end

  agent_key = device['device']['agentKey']
  Chef::Log.info("Using agent key '#{ agent_key }'")

  node['serverdensity']['agent_key'] = agent_key

when 2..3
  
  tokens = node['serverdensity']['api_v2_token']

  if token.nil?
    Chef::Log.fatal("No Server Density OAuth2 token (api_v2_token) set, either set this or set agent_key")
  end

  base_url = "#{ node['serverdensity']['api_v2_base_url'] }/"
  client = Chef::REST::RESTRequest.new("GET", "#{ base_url }inventory/devices/{ node[:hostname] }/byhostname?token=#{ token }")
  response = client.call {|r| r.read_body}

  if Integer(response.headers.status) >= 300
    Chef::Log.info("Couldn't find device, creating a new one")

    # Create new device
    data = {
      'name' => node[:node_name],
      'hostname' => node[:hostname],
      'group' => group(node)
    }

    client = Chef::REST::RESTRequest.new("POST", "#{ base_url }inventory/devices/", form_encode(data))
    response = client.call {|r| r.read_body}

  end

  device = Chef::JSONCompat.from_json(response.body.chomp)
  agent_key = device['agentKey']
  Chef::Log.info("Using agent key '#{ agent_key }'")

  node['serverdensity']['agent_key'] = agent_key

end
