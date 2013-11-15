def whyrun_supported?
  true
end

action :configure do
  if node.serverdensity.enabled
    converge_by "configure sd-agent and ensure it's running" do
      configure
    end
  else
    if service.running
      converge_by "stop sd-agent" do
        service.run_action :stop
        @new_resource.updated_by_last_action true
      end
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
    when @new_resource.username && @new_resource.password
      ServerDensity::API.new 1.4, @new_resource.account, @new_resource.username, @new_resource.password
    else
      nil
  end
end

def configure
  node.normal[:serverdensity][:agent_key] = agent_key

  if agent_key.nil?
    raise 'Unable to acquire a ServerDensity agent_key'
  end

  template.cookbook 'serverdensity'
  template.path '/etc/sd-agent/config.cfg'
  template.source 'config.cfg.erb'
  template.mode 00644
  template.variables node.serverdensity.to_hash

  template.run_action :create

  if template.updated_by_last_action?
    if service.running
      service.run_action :restart
    else
      service.run_action :enable unless service.enabled
      service.run_action :start
    end
    @new_resource.updated_by_last_action true
  end

  synchronize
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
    group: node.serverdensity.device_group || 'chef-autodeploy',
    hostname: node.hostname,
    name: @new_resource.name
  }.merge @new_resource.metadata
end

def service
  @service ||= begin
    service = Chef::Resource::Service.new(@new_resource.name, run_context)
    service.service_name 'sd-agent'
    service
  end
end

def synchronize
  if @new_resource.token and not @new_resource.metadata.empty?
    converge_by "update metadata on Server Density" do
      api.update device, metadata
    end
  end
end

def template
  @template ||= Chef::Resource::Template.new(@new_resource.name, run_context)
end

def validate(key)
  key.match(/^\w{32}$/) ? key : nil
end
