action :install do
  if node.serverdensity.enabled
    install
  else
    service 'sd-agent' do
      action :stop
    end
  end
end

action :uninstall do
  include_recipe 'serverdensity[uninstall]'
end

def agent_key
  @agent_key ||= @new_resource.agent_key ||
    key_from_file || key_from_ec2 || key_from_api
end

def api
  @api ||= case
    when @new_resource.token
      ServerDensity::API.new 2.0, @new_resource.token
    when @new_resource.user && @new_resource.password
      ServerDensity::API.new 1.4, @new_resource.account, @new_resource.user, @new_resource.password
    else
      nil
  end
end

def configure
  node.normal[:serverdensity][:agent_key] = agent_key
  config = node.serverdensity.to_hash

  if config['agent_key'].nil?
    raise 'Unable to acquire a ServerDensity agent_key'
  end

  template '/etc/sd-agent/config.cfg' do
    source 'config.cfg.erb'
    mode 00644
    variables config
    notifies :restart, 'service[sd-agent]'
  end
end

def device
  @device ||= begin
    return unless api

    device = if filter and api.version >= 2
      api.find filter
    else
      api.find :hostname => node.hostname
    end

    if device.nil?
      device = api.create metadata
    end

    device
  end
end

def filter
  if @agent_key
    {:agentKey => agent_key}
  else
    @new_resource.filter
  end
end

def install
  include_recipe 'serverdensity[install]'

  configure

  service 'sd-agent' do
    action [:enable, :start]
  end

  synchronize
end

def key_from_file
  validate ::File.read '/etc/sd-agent-key' if ::File::exist? '/etc/sd-agent-key'
end

def key_from_ec2
  if node.attribute?(:ec2)
    validate RestClient.get('http://169.254.169.254/latest/user-data').split(':').last rescue nil
  end
end

def key_from_api
  validate device['agentKey'] if device
end

def metadata
  @metadata ||= {
    group: 'chef-autodeploy',
    hostname: node.hostname,
    name: @new_resource.name
  }.merge @new_resource.metadata
end

def synchronize
  if not @new_resource.metadata.empty? and api and api.version >= 2
    api.update device, metadata
  end
end

def validate(key)
  key.match(/^\w{32}$/) ? key : nil
end
