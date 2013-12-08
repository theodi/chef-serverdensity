#
# Cookbook Name:: serverdensity
# Provider:: alert

def whyrun_supported?
  true
end

# actions

action :create do
  next unless node.serverdensity.enabled
  converge_by 'add Server Density alert' do
    alert = device.watch(@new_resource.metadata)
    @new_resource.updated_by_last_action !alert.nil?
  end if device
end

# methods

def define_resource_requirements
  requirements.assert(:all_actions) do |a|
    a.assertion { ServerDensity::API.configured? }
    a.failure_message Exception, 'Server Density API has not be configured'
  end
end

def device
  @device ||= ServerDensity::Device.find(@new_resource.device)
end
