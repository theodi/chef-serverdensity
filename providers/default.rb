#
# Cookbook Name:: serverdensity
# Provider:: default

def whyrun_supported?
  true
end

# actions

action :configure do
  if node.serverdensity.enabled
    setup
    configure
    enable
    sync
  else
    disable
  end
end

# tasks

def configure
  converge_by 'fetch Server Density agent key' do
    node.normal.serverdensity.agent_key = agent_key
    raise 'Unable to acquire a ServerDensity agent_key' if agent_key.nil?
  end

  template.cookbook 'serverdensity'
  template.source 'config.cfg.erb'

  template.path '/etc/sd-agent/config.cfg'
  template.mode 00644

  template.variables Chef::Mixin::DeepMerge.deep_merge(
    node.serverdensity.to_hash,
    @new_resource.settings
  )

  template.run_action :create

  @new_resource.updated_by_last_action template.updated_by_last_action?
end

def disable
  if service.running
    service.run_action :stop
    @new_resource.updated_by_last_action true
  end
end

def enable
  if service.running
    service.run_action :restart if @new_resource.updated_by_last_action?
  else
    service.run_action :enable unless service.enabled
    service.run_action :start
    @new_resource.updated_by_last_action true
  end
end

def setup
  case
    when @new_resource.token
      ServerDensity::API.configure 2.0, @new_resource.token
    when @new_resource.username && @new_resource.password
      ServerDensity::API.configure 1.4, @new_resource.account, @new_resource.username, @new_resource.password
  end
end

def sync
  unless @new_resource.metadata.empty?
    converge_by "update metadata on Server Density" do
      device.update metadata if device
    end
  end
end

# utils

def agent_key
  @agent_key ||= @new_resource.agent_key ||
    key_from_file || key_from_ec2 || key_from_api
end

def key_from_api
  validate device.agentKey if device
end

def key_from_ec2
  if node.attribute?(:ec2)
    validate RestClient.get('http://169.254.169.254/latest/user-data').split(':').last rescue nil
  end
end

def key_from_file
  validate ::File.read '/etc/sd-agent-key' if ::File::exist? '/etc/sd-agent-key'
end

def validate(key)
  key.match(/^\w{32}$/) ? key : nil
end

# helpers

def device
  return unless ServerDensity::API.configured?
  @device ||=
    ServerDensity::Device.find(@new_resource.device || @new_resource.name) ||
    ServerDensity::Device.create(metadata)
end

def metadata
  @metadata ||= {
    group: node.serverdensity.device_group || 'chef-autodeploy',
    hostname: node.hostname,
    name: @new_resource.name
  }.merge @new_resource.metadata
end

# resources

def service
  @service ||= begin
    service = Chef::Resource::Service.new(@new_resource.name, run_context)
    service.service_name 'sd-agent'
    service
  end
end

def template
  @template ||= Chef::Resource::Template.new(@new_resource.name, run_context)
end
