#
# Cookbook Name:: serverdensity
# Provider:: plugin

def whyrun_supported?
  true
end

# actions

action :enable do
  config.run_action :create
  plugin.run_action :create
  new_resource.updated_by_last_action(
    config.updated_by_last_action? || plugin.updated_by_last_action?
  )
end

action :disable do
  config.run_action :delete
  plugin.run_action :delete
  new_resource.updated_by_last_action(
    config.updated_by_last_action? || plugin.updated_by_last_action?
  )
end

# methods

def config
  @config ||= begin
    file = Chef::Resource::Template.new ::File.join(
      '/etc/sd-agent/conf.d', "plugin-#{new_resource.name}.cfg"
    ), run_context
    file.cookbook 'serverdensity'
    file.source 'plugin.cfg.erb'
    file.variables :name => new_resource.name,
                   :options => new_resource.config
    file
  end
end

def plugin
  @plugin ||= begin
    file = Chef::Resource::Link.new ::File.join(
      node.serverdensity.plugin_dir, new_resource.name + '.py'
    ), run_context
    file.to new_resource.path
    file
  end
end
